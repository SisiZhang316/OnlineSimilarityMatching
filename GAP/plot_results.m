%% display results simulation 
clear all
files=dir('*.mat')
figure
hold all
legends={};
cm=colormap(hot(numel(files)+10));
d_s=[];
q_s=[];
err_s=[];
errhalf_s=[];
for f=1:numel(files)
   disp(files(f).name)
   load(files(f).name,'d','q','errors_real')
   legends{f}=files(f).name;
   plot((median(errors_real,2)),'d','Linewidth',2,'Color',cm(f+5,:))
   err_s=[ err_s errors_real(end,:)'];
   d_s=[d_s d];
   q_s=[q_s q];
   legend(legends{:},'Interpreter', 'none')   
%     input('')

end
legend(legends, 'Interpreter', 'none')
xlabel('Samples')
ylabel('Eigenspace Estimation Error pca vs batch')


%% ** LOAD  files and create manageable data structure **. You need to set load_times=1 if you want to measure the times
clear all
files=dir('*.mat');
files = struct2cell(files);
files = files(1,:);
load_times=0;

times_tot=[];
err_real=[];
err_batch=[];
err_online=[];
err_reconstr=[];
err_of_pca=[];
err_reconstr_pca=[];
err_sim_pca=[];
err_sim=[];

d_s=[];
q_s=[];
rho_s=[];
methods_={};
for f=1:numel(files)
   disp(f)  
   load(files{f},'options_algorithm','options_generator','options_simulations','d','q','times_',...
                            'errors_similarity','errors_real','errors_batch_pca','errors_online','errors_reconstr',...
                            'errors_reconstr_pca','errors_of_pca'...
                            ,'errors_similarity_pca')
   test_method=options_algorithm.pca_algorithm;  
   if load_times
       times_=diff(times_);
       times_iter=times_(:)';
    %    times_iter=nanmean(times_,1); 
       numIter=numel(times_iter);
       times_tot=[times_tot times_iter];
   else
       numIter=size(errors_batch_pca,2);
   end

   idx_not_nan=find(~isnan(nanmedian(errors_real,2)) | ~isnan(nanmedian(errors_batch_pca,2)));
   if ~load_times && ~isempty(idx_not_nan)       
       err_real=[err_real errors_real(idx_not_nan(end),:)];
       err_batch=[err_batch errors_batch_pca(idx_not_nan(end),:)];
       err_online=[err_online nanmean(errors_online(idx_not_nan,:),1)]; 
       try
           err_reconstr=[err_reconstr errors_reconstr(idx_not_nan(end),:)]; 
           err_sim=[err_sim errors_similarity(idx_not_nan(end),:)]; 
           err_of_pca=[err_of_pca errors_of_pca(idx_not_nan(end),:)];
           err_sim_pca=[err_sim_pca errors_similarity_pca(idx_not_nan(end),:)];
           err_reconstr_pca=[err_reconstr_pca errors_reconstr_pca(idx_not_nan(end),:)];
       catch
           disp('did not load sim and reconstr error')
       end
   end
   d_s=[d_s repmat(d,1,numIter)];
   q_s=[q_s repmat(q,1,numIter)];
   rho_s=[rho_s repmat(options_generator.rho,1,numIter)];
   newm={};
   for ll=1:numIter
       newm{ll}=test_method;
   end
   methods_=[methods_ newm];
end
%% errors plot
jj=0;
is_projection_error=1;
if is_projection_error
    %figure('name','Projection Error')    
     error=err_batch;  
%       error=err_real;
%     error=err_of_pca;
else
%     figure('name','Reconstruction Error')
%     error=err_reconstr_pca;
    error=err_reconstr;
%     error=err_sim;
%     error=err_sim_pca;
    
end


cm1=hot(8);
cm2=(gray(10));
cm3=colormap(lines);

stats_={'nanmean','iqr'};
%stats_={@(X) quantile(X,.5),@(X) 0};

col_var=d_s;
col_var2=q_s;
for cv=unique(col_var)
    for cv2=unique(col_var2)
        legend off
        if ~isempty(find(col_var==cv & col_var2==cv2,1))
            jj=jj+1;
            subplot(5,4,jj)
            
            idx=find(col_var==cv & col_var2==cv2 & strcmp(methods_,'H_AH_NN_PCA'));
            xvar=rho_s(idx);
            xax=unique(xvar);
            [me_h,ma_h]=grpstats(error(idx),xvar,stats_);
            errorbar(xax, me_h,ma_h ,'.-','color',[0 0 0],'linewidth',1.5);
            
            
            hold on
            idx=find(col_var==cv & col_var2==cv2 & strcmp(methods_,'IPCA'));
            xvar=rho_s(idx);
            xax=unique(xvar);
            [me_i,ma_i]=grpstats(error(idx),xvar,stats_);
            errorbar(xax, me_i,ma_i,'--','color',[1 0 0]);
            if is_projection_error
           %     text(max(xax),max(me_i),['q = ' num2str(cv2)],'fontsize',10)
            else
            %    text(min(xax),min(me_i),['q = ' num2str(cv2)],'fontsize',10)
            end
            
             
            idx=find(col_var==cv & col_var2==cv2 & strcmp(methods_,'SGA'));
            xvar=rho_s(idx);
            xax=unique(xvar);
            [me_i,ma_i]=grpstats(error(idx),xvar,stats_);
            errorbar(xax, me_i,ma_i,'--','color',[0 .6 0]);
%             set(gca,'xscale','log')
            set(gca,'yscale','log')
            
            
            idx=find(col_var==cv & col_var2==cv2 & strcmp(methods_,'SEQ_SIM_PCA'));
            xvar=rho_s(idx);
            xax=unique(xvar);
            [me_i,ma_i]=grpstats(error(idx),xvar,stats_);
            errorbar(xax, me_i,ma_i,'--','color',[0 0 0.6]);
%             set(gca,'xscale','log')
            set(gca,'yscale','log')
            
            idx=find(col_var==cv & col_var2==cv2 & strcmp(methods_,'CCIPCA'));
            xvar=rho_s(idx);
            xax=unique(xvar);
            [me_i,ma_i]=grpstats(error(idx),xvar,stats_);
            errorbar(xax, me_i,ma_i,'--','color',[0 0.6 0.6]);
%             set(gca,'xscale','log')
            set(gca,'yscale','log')
            
            if is_projection_error
                legend('SIM','IPCA','SGA','SEQ_OSM','CCIPCA','location','NorthWest')
            else
                legend('SIM','IPCA','SGA','SEQ_OSM','CCIPCA','location','SouthEast')
            end
            
            
            
%             ylim([.001 1.1])
%             xlim([0 1.1])
            axis tight
            xlabel('rho')
            if is_projection_error
                ylabel('Projection Error')
            else
                ylabel('Reconstruction Error')
            end
            title(['d=' num2str(cv) ' q=' num2str(cv2)])
        end
    end
end
%
% get handle to current axes
a = gca;
% set box property to off and remove background color
box off

if is_projection_error
    fname=['Proj_error_' num2str(cv) '.fig']
    fname1=['Proj_error_' num2str(cv) '.eps']
   
else
    fname=['Reconstr_error_' num2str(cv) '.fig']   
    fname1=['Reconstr_error_' num2str(cv) '.eps']   
end
saveas(gcf,fname) 
exportfig(gcf,fname1,'color','cmyk','fontsize',2,'width',7,'height',12)
%% time plot IF YOU WANT TO RUN THIS YOU NEED TO SET load_times=1
figure
jj=0;
ttime=times_tot;

cm1=hot(8);
cm2=(gray(10));
cm3=(autumn(10));
% stats_={'nanmean',@(X) mad(X,1),@(X) quantile(X,.25),@(X) quantile(X,.75)};
stats_={'nanmean',@(X) iqr(X),@(X) quantile(X,.25),@(X) quantile(X,.75)};

col_var=d_s;
for cv=unique(col_var)
    if ~isempty(find(col_var==cv,1))
        if ~isempty(find(col_var==cv ,1))
            jj=jj+1;
            
            subplot(3,3,jj)
            
            idx=find(col_var==cv & strcmp(methods_,'H_AH_NN_PCA'));
            xvar=q_s(idx);
            xax=unique(xvar);
            [me_h,ma_h,ql_h,qh_h]=grpstats(ttime(idx),xvar,stats_);
            errorbar(xax+normrnd(0,.01,size(xax)), me_h,ma_h,'o-','MarkerSize',6,'MarkerFaceColor',[0 0 0],'color',[0 0 0]);
            
            hold on
            idx=find(col_var==cv & strcmp(methods_,'IPCA'));
            xvar=q_s(idx);
            xax=unique(xvar);
            [me_i,ma_i,ql_i,qh_i]=grpstats(ttime(idx),xvar,stats_);
            errorbar(xax+normrnd(0,.01,size(xax)), me_i,ma_i,'o-','MarkerSize',6,'MarkerFaceColor',[1 0 0],'color',[1 0 0]);
            
            hold on
            idx=find(col_var==cv & strcmp(methods_,'CCIPCA'));
            xvar=q_s(idx);
            xax=unique(xvar);
            [me_i,ma_i,ql_i,qh_i]=grpstats(ttime(idx),xvar,stats_);
            errorbar(xax+normrnd(0,.01,size(xax)), me_i,ma_i,'o-','MarkerSize',6,'MarkerFaceColor',[0 0.6 0.6],'color',[0 0.6 0.6]);
            
            
            
%             idx=find(col_var==cv & strcmp(methods_,'SGA'));
%             xvar=q_s(idx);
%             xax=unique(xvar);
%             [me_i,ma_i,ql_i,qh_i]=grpstats(ttime(idx),xvar,stats_);
%             errorbar(xax+normrnd(0,.01,size(xax)), me_i,ma_i,'o-','MarkerSize',6,'MarkerFaceColor',[0 .6 0],'color',[0 .6 0]);
            
            
            
            legend('SIM','IPCA','CCIPCA','SGA')
            set(gca,'yscale','log')
            set(gca,'xscale','log')
            xlabel('q')
            ylabel('time (ms)')
            
            %ylim([2*1e-4 2])
            axis square
            title(['d=' num2str(cv)])
            
            
        end
    end
end

%%
clear all
files=dir('*.mat');
% dirFlags = [files.isdir];
% files=files(dirFlags);
files = struct2cell(files);
files = files(1,:);
%% error plot online
clear all
files_to_analize = uipickfiles()
%%
figure('name','error_online')

for jj=1:numel(files_to_analize)
    load(files_to_analize{jj})
    idx=find(~isnan(quantile(errors_real',.05)));

    subplot(4,3,jj)
    
    hold all
    plot(idx,quantile(errors_real(idx,:)',.05),'-o')
    plot(idx,quantile(errors_online(idx,:)',.05),'-o')
    plot(idx,quantile(errors_batch_pca(idx,:)',.05),'-o')
    xlabel('Samples')
    ylabel('Projection error')
    title(['d=' num2str(d) ',q=' num2str(q) ',algo=' pca_algorithm ',rho=' num2str(options_generator.rho)])
    axis tight
    set(gca,'xscale','log')
    set(gca,'yscale','log')
    set(gca, 'box', 'off')
    
    
end
legend('model-based','online','data-based')
%% FROM HERE ON IT MIGHT BE OBSOLETE
%%
files=uipickfiles;
%%
figure
clear all
files=dir('*.mat')
% dirFlags = [files.isdir];
% files=files(dirFlags);
files = struct2cell(files);
files = files(1,:);
hold all
legends={};
cm1=hot(20+numel(files));
cm2=flipud(gray(numel(files)))
cm3=flipud(autumn(numel(files)))

% cm=colormap(hot(20))
colq=[];
for f=1:numel(files)    
   disp(f)
   load(files{f},'options_algorithm','options_generator','options_simulations','d','q','errors_online')
   errors=errors_online;
   if ~isfield(options_generator,'rho')
        warning('setting rho to 0 because not existing field!')
        options_generator.rho=0;
   end
   legends{f}=files{f};
   test_method=options_algorithm.pca_algorithm;
   %legends{f}=['input dim=' num2str(d)];
   legends{f}=[test_method ' rho = ' num2str(options_generator.rho) ' d = ' num2str(d) ' n0 = ' num2str(options_simulations.n0)];

   if isequal(test_method,'IPCA')
        symbol='d';
        colr=cm1(20+f,:);
        colr=cm1(20,:);
        shift=0;
    elseif isequal(test_method,'H_AH_NN_PCA')
        symbol='o';
        colr=cm2(f,:);
        colr=cm2(20,:);
        shift=0;
    else
        symbol='s';
        colr=cm3(f,:);
        shift=0;
   end
   vr= options_generator.rho;
%    colq(f)=errorbar(vr+normrnd(0,vr/50,size(vr)),nanmedian(errors(end,:)),quantile(errors(end,:),.25),quantile(errors(end,:),.75),'ko','MarkerFaceColor',colr,'MarkerSize',10) ;
   colq(f)=scatter(vr+normrnd(0,vr/50,size(vr)),nanmedian(errors(end,:)),'ko','MarkerFaceColor',colr) ;
   set(gca,'yscale','log')
   set(gca,'xscale','log')
%    legend(legends{:})   
% input('')
end
[vals,idx]=unique(legends)
legend(colq(idx),legends{idx}, 'Interpreter', 'none')
xlabel(['output dim'], 'Interpreter', 'none')
ylabel('Projection Error')
saveas(gcf,'ProjErrors.jpg')
saveas(gcf,'ProjErrors.fig')
%%
clear all
files=dir('*.mat')
% dirFlags = [files.isdir];
% files=files(dirFlags);
files = struct2cell(files);
files = files(1,:);
cm1=hot(20+numel(files));
cm2=flipud(gray(numel(files)))
cm3=flipud(autumn(numel(files)))
figure
hold all
legends={};
% cm=colormap(hot(20))
colq=[];
for f=1:numel(files)
   disp(f)
   load(files{f},'options_algorithm','options_generator','options_simulations','d','q','times_')
   legends{f}=files{f};
   times_=diff(times_);
   test_method=options_algorithm.pca_algorithm;
   %legends{f}=['input dim=' num2str(d)];
   legends{f}=[test_method ' rho = ' num2str(options_generator.rho) ' d = ' num2str(d) ' n0 = ' num2str(options_simulations.n0)];

   if isequal(test_method,'IPCA')
        symbol='d';
        colr=cm1(20+f,:);
        shift=0;
    elseif isequal(test_method,'H_AH_NN_PCA')
        symbol='o';
        colr=cm2(f,:);
        shift=0;
    else
        symbol='s';
        colr=cm3(f,:);
        shift=0;
   end
   vr=q;
   colq(f)=errorbar(vr+normrnd(0,vr/50,size(vr)),nanmedian(times_(:)*1000),quantile(times_(:)*1000,.25),quantile(times_(:)*1000,.75),'ko','MarkerFaceColor',colr,'MarkerSize',10) ;
   set(gca,'yscale','log')
   set(gca,'xscale','log')
%    legend(legends{:})   
% input('')
end
[vals,idx]=unique(legends);
legend(colq(idx),legends{idx}, 'Interpreter', 'none')
xlabel('output dim' , 'Interpreter', 'none')
ylabel('Time per iteration (ms)')
saveas(gcf,'TimeIter.jpg')
saveas(gcf,'TimeIter.fig')
%% ********************************** PLOT FOR GAPS *****************************************
clear all
files_to_analize = uipickfiles()
%%
files_to_analize=dir('*')
files_to_analize(1:2)=[];
dirFlags = [files_to_analize.isdir];
files_to_analize=files_to_analize(dirFlags);
files_to_analize = struct2cell(files_to_analize);
files_to_analize = files_to_analize(1,:);
%%
files_to_analize=dir('*.mat')
% dirFlags = [files.isdir];
% files=files(dirFlags);
files_to_analize = struct2cell(files_to_analize);
files_to_analize = files_to_analize(1,:);
%%
figure
hold on
legends={};
cm1=(hot(8));
cm2=(gray(10));
cm3=(autumn(10));

colq=[];
for ff=1:numel(files_to_analize)
    disp(files_to_analize{ff})   
    load(files_to_analize{ff},'options_algorithm','options_generator','options_simulations','d','q','errors_online','errors_real','errors_batch_pca','error_orth')
    test_method=options_algorithm.pca_algorithm;
    drawnow 

    errors=errors_batch_pca;
    legends{ff}=[test_method ' rho = ' num2str(options_generator.rho) ' d = ' num2str(d) ' n0 = ' num2str(options_simulations.n0)];
    if isequal(test_method,'IPCA')
        symbol='d';
        colr=cm2(5,:)
        shift=0;
    elseif isequal(test_method,'H_AH_NN_PCA')        
        symbol='o';
        colr=cm1(5,:)
        shift=1;
    elseif isequal(test_method,'SGA')
        symbol='s';
        colr=cm3(5,:)
        shift=0;
    end
    errline=nanmedian(errors');    
    idx_not_nan=find(~isnan(errline));
    
    colq(ff)=errorbar(idx_not_nan+shift,nanmedian(errors(idx_not_nan,:)'),mad(errors(idx_not_nan,:)',1),['-' symbol],'color',colr,'MarkerFaceColor',colr,'MarkerSize',10) ;
%     colq(ff)=plot(idx_not_nan+shift,nanmedian(errors(idx_not_nan,:)'),['-' symbol],'color',colr,'MarkerFaceColor',colr,'MarkerSize',10) ;

end
legend(legends,'Interpreter', 'none')
xlabel('Samples', 'Interpreter', 'none')
ylabel('Projection error')
set(gca,'yscale','log')
set(gca,'xscale','log')


%%
clear all
files=dir('*.mat')
% dirFlags = [files.isdir];
% files=files(dirFlags);
files = struct2cell(files);
files = files(1,:);
nfiles=numel(files)
cm1=hot(20+nfiles);
cm2=flipud(gray(nfiles));
cm3=flipud(autumn(nfiles));
figure
hold all
legends={};
colq=[];
for f=1:numel(files)
   disp(f)  
   load(files{f},'options_algorithm','options_generator','options_simulations','d','q','times_','errors_online')
   legends{f}=files{f};
   times_=diff(times_);
   test_method=options_algorithm.pca_algorithm;
   errors=errors_online;
   if isequal(test_method,'IPCA')
        symbol='d';
        colr=cm1(nfiles/2,:);
        shift=1;
   elseif  isequal(test_method,'H_AH_NN_PCA')
        symbol='o';
        colr=cm2(nfiles/2,:);
        shift=1;
   else
        symbol='s';
        colr=cm3(f*2,:);
        shift=0;
   end    
   
   xvarname='rho';
   xvar=options_generator.rho;
   xvarname='q';
   xvar=d;
   %colq(f)=errorbar(xvar,nanmedian(times_(:)*1000),mad(times_(:)*1000,.25),'ko','MarkerFaceColor',colr,'MarkerSize',10) ;
   times_iter=times_(:)*1000;
%    colq(f)=errorbar(xvar+ normrnd(0,xvar/20),nanmedian(times_iter),quantile(times_iter,.25),quantile(times_iter,.75),'ko','MarkerFaceColor',colr,'MarkerSize',10) ;
   colq(f)=errorbar(xvar+ normrnd(0,xvar/20),nanmedian(times_iter),mad(times_iter,1),'ko','MarkerFaceColor',colr,'MarkerSize',10) ;

%    legend(legends{:})   
% input('')
end
[vals,idx]=unique(legends)
legend(colq(idx),legends{idx}, 'Interpreter', 'none')
xlabel(xvarname, 'Interpreter', 'none')
ylabel('Time per iteration (ms)')
set(gca,'yscale','log')
set(gca,'xscale','log')
saveas(gcf,'TimeIter.jpg')
saveas(gcf,'TimeIter.fig')



