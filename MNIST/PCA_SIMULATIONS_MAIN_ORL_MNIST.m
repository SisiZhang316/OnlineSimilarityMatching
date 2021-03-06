clear all

options_simulations=struct;

options_simulations.outer_iter=1;
options_simulations.n0=0;
options_simulations.niter=40;
options_simulations.nstep_skip_EIGV_errors=128;
options_simulations.initialize_PCA=0;
options_simulations.orthonormalize_vectors=1;
options_simulations.compute_error_batch=1;
options_simulations.compute_error_real=0;
options_simulations.compute_error_online=0;
options_simulations.normalize_input=1;
options_simulations.orthonormalize_weights=0;
options_simulations.compute_error_similarity=1;
options_simulations.compute_error_reconstruction=1;
options_simulations.compute_error_reconstruction_pca=1;
options_simulations.compute_proj_errors_of_pca=0;
options_simulations.compute_errors_similarity_pca=1;



%% MNIST
options_generator=struct;
options_generator.method='MNIST';%load MNIST Data;
% options_generator.rho=0;
% options_generator.lambda=0;

format compact
t = datetime('now');
folder_exp=['MNIST_n0_' num2str(options_simulations.n0) '_niter' num2str(options_simulations.niter) '_' char(t)];
mkdir(folder_exp)
options_generator.n=1024*2;
options_simulations.perc_samp_extra_test=.2;
options_generator.d=784;
%%
close
hold all
legends={};
cm=hot(220);
counter=0;

for q=[4 16 64 128 256]
    for norm_scale=[2*pi]
        options_generator.q=q;
        disp(q)
        options_simulations.normalization_scale=1;
        options_simulations.init_weight_mult=norm_scale;%10/q;

        
        options_algorithm=struct();
        options_algorithm.pca_algorithm='IPCA';
        options_algorithm.q=options_generator.q;
        options_algorithm.tol=1e-7;
        [errors_real,errors_batch_pca,errors_online,errors_reconstr,errors_similarity,times_,fname]=Online_PCA_simulations(folder_exp,options_simulations,options_generator,options_algorithm);
        hold all
        if ~isempty(errors_real)
            axs=[];
            counter=counter+1;
            cols=cm(100,:);
            axs(1)=plot(0,0);
            load(fullfile(folder_exp,[fname '.mat']),'errors_reconstr_pca')
            axs(1)=plot(median(errors_reconstr_pca,2),'d','Linewidth',2,'color','b');
            axs(2)=plot(median(errors_batch_pca,2),'+','Linewidth',2,'color','m');
%                 axs(3)=plot(median(errors_online,2),'*','Linewidth',2,'color',cols);
            axs(3)=plot(median(errors_similarity,2),'+','Linewidth',2,'color','r');
            axs(4)=plot(median(errors_reconstr,2),'*','Linewidth',2,'color','k');
%                 legend(axs,{'real','batch pca','online'}, 'Interpreter', 'none')
            xlabel(fname)
            ylabel('Projection error')
            drawnow
        end

        options_algorithm=struct();
        options_algorithm.pca_algorithm='CCIPCA';
        options_algorithm.q=options_generator.q;
        options_algorithm.tol=1e-7;
        [errors_real,errors_batch_pca,errors_online,errors_reconstr,errors_similarity,times_,fname]=Online_PCA_simulations(folder_exp,options_simulations,options_generator,options_algorithm);
        cla
        hold all
        if ~isempty(errors_real)
            axs=[];
            counter=counter+1;
            cols=cm(100,:);
            axs(1)=plot(0,0);
            load(fullfile(folder_exp,[fname '.mat']),'errors_reconstr_pca')
            axs(1)=plot(median(errors_reconstr_pca,2),'d','Linewidth',2,'color','b');
            axs(2)=plot(median(errors_batch_pca,2),'+','Linewidth',2,'color','m');
%                 axs(3)=plot(median(errors_online,2),'*','Linewidth',2,'color',cols);
            axs(3)=plot(median(errors_similarity,2),'+','Linewidth',2,'color','r');
            axs(4)=plot(median(errors_reconstr,2),'*','Linewidth',2,'color','k');
%                 legend(axs,{'real','batch pca','online'}, 'Interpreter', 'none')
            xlabel(fname)
            ylabel('Projection error')
            drawnow
        end
        
        options_algorithm=struct();
        options_algorithm.pca_algorithm='H_AH_NN_PCA';
        options_algorithm.q=options_generator.q;
        options_algorithm.update_method='ls';
        options_algorithm.tol=1e-5;
        [errors_real,errors_batch_pca,errors_online,errors_reconstr,errors_similarity,times_,fname]=Online_PCA_simulations(folder_exp,options_simulations,options_generator,options_algorithm);
        if ~isempty(errors_real)
            axs=[];
            counter=counter+1;
            cols=cm(100,:);
            axs(1)=plot(0,0);
            load(fullfile(folder_exp,[fname '.mat']),'errors_reconstr_pca')
            axs(1)=plot(median(errors_reconstr_pca,2),'d','Linewidth',2,'color','c');
            axs(2)=plot(median(errors_batch_pca,2),'+','Linewidth',2,'color','g');
%                 axs(3)=plot(median(errors_online,2),'*','Linewidth',2,'color',cols);
            axs(3)=plot(median(errors_similarity,2),'+','Linewidth',2,'color',[.8 .8 .8]);
            axs(4)=plot(median(errors_reconstr,2),'*','Linewidth',2,'color','y');
%                 legend(axs,{'real','batch pca','online'}, 'Interpreter', 'none')
            xlabel(fname)
            ylabel('Projection error')
            drawnow
        end
        hold all
        
%         
%         options_algorithm=struct();
%         options_algorithm.pca_algorithm='SEQ_SIM_PCA';
%         options_algorithm.q=options_generator.q;
%         options_algorithm.update_method='ls';
%         options_algorithm.tol=1e-5;
%         [errors_real,errors_batch_pca,errors_online,errors_reconstr,errors_similarity,times_,fname]=Online_PCA_simulations(folder_exp,options_simulations,options_generator,options_algorithm);
%         hold all
%         if ~isempty(errors_real)
%             axs=[];
%             counter=counter+1;
%             cols=cm(100,:);
%             axs(1)=plot(0,0);
%             load(fullfile(folder_exp,[fname '.mat']),'errors_reconstr_pca')
%             axs(1)=plot(median(errors_reconstr_pca,2),'d','Linewidth',2,'color','b');
%             axs(2)=plot(median(errors_batch_pca,2),'+','Linewidth',2,'color','m');
% %                 axs(3)=plot(median(errors_online,2),'*','Linewidth',2,'color',cols);
%             axs(3)=plot(median(errors_similarity,2),'+','Linewidth',2,'color','r');
%             axs(4)=plot(median(errors_reconstr,2),'*','Linewidth',2,'color','k');
% %                 legend(axs,{'real','batch pca','online'}, 'Interpreter', 'none')
%             xlabel(fname)
%             ylabel('Projection error')
%             drawnow
%         end
        
%         pause
%         cla
        
    end
end
%% ORL
options_generator=struct;
options_generator.method='ORL';%load MNIST Data;
t = datetime('now');
folder_exp=['ORL_n0_' num2str(options_simulations.n0) '_niter' num2str(options_simulations.niter) '_' char(t)];
mkdir(folder_exp)
options_simulations.perc_samp_extra_test=.2;
options_generator.n=floor(400/(1+options_simulations.perc_samp_extra_test));
options_generator.d=1024;
%%
close
hold all
legends={};
cm=hot(220);
counter=0;

for q=[4 16 64 128 256]
    for norm_scale=[2*pi]
        options_generator.q=q;
        disp(q)
        options_simulations.normalization_scale=1;
        options_simulations.init_weight_mult=norm_scale;%10/q;

        
        options_algorithm=struct();
        options_algorithm.pca_algorithm='IPCA';
        options_algorithm.q=options_generator.q;
        options_algorithm.tol=1e-7;
        [errors_real,errors_batch_pca,errors_online,errors_reconstr,errors_similarity,times_,fname]=Online_PCA_simulations(folder_exp,options_simulations,options_generator,options_algorithm);
        hold all
        if ~isempty(errors_real)
            axs=[];
            counter=counter+1;
            cols=cm(100,:);
            axs(1)=plot(0,0);
            load(fullfile(folder_exp,[fname '.mat']),'errors_reconstr_pca')
            axs(1)=plot(median(errors_reconstr_pca,2),'d','Linewidth',2,'color','b');
            axs(2)=plot(median(errors_batch_pca,2),'+','Linewidth',2,'color','m');
%                 axs(3)=plot(median(errors_online,2),'*','Linewidth',2,'color',cols);
            axs(3)=plot(median(errors_similarity,2),'+','Linewidth',2,'color','r');
            axs(4)=plot(median(errors_reconstr,2),'*','Linewidth',2,'color','k');
%                 legend(axs,{'real','batch pca','online'}, 'Interpreter', 'none')
            xlabel(fname)
            ylabel('Projection error')
            drawnow
        end

        
        options_algorithm=struct();
        options_algorithm.pca_algorithm='H_AH_NN_PCA';
        options_algorithm.q=options_generator.q;
        options_algorithm.update_method='ls';
        options_algorithm.tol=1e-5;
        [errors_real,errors_batch_pca,errors_online,errors_reconstr,errors_similarity,times_,fname]=Online_PCA_simulations(folder_exp,options_simulations,options_generator,options_algorithm);
        if ~isempty(errors_real)
            axs=[];
            counter=counter+1;
            cols=cm(100,:);
            axs(1)=plot(0,0);
            load(fullfile(folder_exp,[fname '.mat']),'errors_reconstr_pca')
            axs(1)=plot(median(errors_reconstr_pca,2),'d','Linewidth',2,'color','c');
            axs(2)=plot(median(errors_batch_pca,2),'+','Linewidth',2,'color','g');
%                 axs(3)=plot(median(errors_online,2),'*','Linewidth',2,'color',cols);
            axs(3)=plot(median(errors_similarity,2),'+','Linewidth',2,'color',[.8 .8 .8]);
            axs(4)=plot(median(errors_reconstr,2),'*','Linewidth',2,'color','y');
%                 legend(axs,{'real','batch pca','online'}, 'Interpreter', 'none')
            xlabel(fname)
            ylabel('Projection error')
            drawnow
        end
        hold all
        
        options_algorithm=struct();
        options_algorithm.pca_algorithm='CCIPCA';
        options_algorithm.q=options_generator.q;
        options_algorithm.tol=1e-7;
        [errors_real,errors_batch_pca,errors_online,errors_reconstr,errors_similarity,times_,fname]=Online_PCA_simulations(folder_exp,options_simulations,options_generator,options_algorithm);
        cla
        hold all
        if ~isempty(errors_real)
            axs=[];
            counter=counter+1;
            cols=cm(100,:);
            axs(1)=plot(0,0);
            load(fullfile(folder_exp,[fname '.mat']),'errors_reconstr_pca')
            axs(1)=plot(median(errors_reconstr_pca,2),'d','Linewidth',2,'color','b');
            axs(2)=plot(median(errors_batch_pca,2),'+','Linewidth',2,'color','m');
%                 axs(3)=plot(median(errors_online,2),'*','Linewidth',2,'color',cols);
            axs(3)=plot(median(errors_similarity,2),'+','Linewidth',2,'color','r');
            axs(4)=plot(median(errors_reconstr,2),'*','Linewidth',2,'color','k');
%                 legend(axs,{'real','batch pca','online'}, 'Interpreter', 'none')
            xlabel(fname)
            ylabel('Projection error')
            drawnow
        end
%         
%         options_algorithm=struct();
%         options_algorithm.pca_algorithm='SEQ_SIM_PCA';
%         options_algorithm.q=options_generator.q;
%         options_algorithm.update_method='ls';
%         options_algorithm.tol=1e-5;
%         [errors_real,errors_batch_pca,errors_online,errors_reconstr,errors_similarity,times_,fname]=Online_PCA_simulations(folder_exp,options_simulations,options_generator,options_algorithm);
%         hold all
%         if ~isempty(errors_real)
%             axs=[];
%             counter=counter+1;
%             cols=cm(100,:);
%             axs(1)=plot(0,0);
%             load(fullfile(folder_exp,[fname '.mat']),'errors_reconstr_pca')
%             axs(1)=plot(median(errors_reconstr_pca,2),'d','Linewidth',2,'color','b');
%             axs(2)=plot(median(errors_batch_pca,2),'+','Linewidth',2,'color','m');
% %                 axs(3)=plot(median(errors_online,2),'*','Linewidth',2,'color',cols);
%             axs(3)=plot(median(errors_similarity,2),'+','Linewidth',2,'color','r');
%             axs(4)=plot(median(errors_reconstr,2),'*','Linewidth',2,'color','k');
% %                 legend(axs,{'real','batch pca','online'}, 'Interpreter', 'none')
%             xlabel(fname)
%             ylabel('Projection error')
%             drawnow
%         end
        
%         pause
%         cla
        
    end
end


%% YALE
options_generator=struct;
options_generator.method='YALE';%load YALE Data;
%
format compact
t = datetime('now');
folder_exp=['YALE_n0_' num2str(options_simulations.n0) '_niter' num2str(options_simulations.niter) '_' char(t)];
mkdir(folder_exp)

legends={};
options_simulations.perc_samp_extra_test=.2;
options_generator.n=floor(2414/(1+options_simulations.perc_samp_extra_test));
options_generator.d=1024;
%%
close
hold all
legends={};
cm=hot(220);
counter=0;

for q=[4 16 64 128 256]
    for norm_scale=[2*pi]
        options_generator.q=q;
        disp(q)
        options_simulations.normalization_scale=1;
        options_simulations.init_weight_mult=norm_scale;%10/q;

        
        options_algorithm=struct();
        options_algorithm.pca_algorithm='IPCA';
        options_algorithm.q=options_generator.q;
        options_algorithm.tol=1e-7;
        [errors_real,errors_batch_pca,errors_online,errors_reconstr,errors_similarity,times_,fname]=Online_PCA_simulations(folder_exp,options_simulations,options_generator,options_algorithm);
        hold all
        if ~isempty(errors_real)
            axs=[];
            counter=counter+1;
            cols=cm(100,:);
            axs(1)=plot(0,0);
            load(fullfile(folder_exp,[fname '.mat']),'errors_reconstr_pca')
            axs(1)=plot(median(errors_reconstr_pca,2),'d','Linewidth',2,'color','b');
            axs(2)=plot(median(errors_batch_pca,2),'+','Linewidth',2,'color','m');
%                 axs(3)=plot(median(errors_online,2),'*','Linewidth',2,'color',cols);
            axs(3)=plot(median(errors_similarity,2),'+','Linewidth',2,'color','r');
            axs(4)=plot(median(errors_reconstr,2),'*','Linewidth',2,'color','k');
%                 legend(axs,{'real','batch pca','online'}, 'Interpreter', 'none')
            xlabel(fname)
            ylabel('Projection error')
            drawnow
        end

        
        options_algorithm=struct();
        options_algorithm.pca_algorithm='H_AH_NN_PCA';
        options_algorithm.q=options_generator.q;
        options_algorithm.update_method='ls';
        options_algorithm.tol=1e-5;
        [errors_real,errors_batch_pca,errors_online,errors_reconstr,errors_similarity,times_,fname]=Online_PCA_simulations(folder_exp,options_simulations,options_generator,options_algorithm);
        if ~isempty(errors_real)
            axs=[];
            counter=counter+1;
            cols=cm(100,:);
            axs(1)=plot(0,0);
            load(fullfile(folder_exp,[fname '.mat']),'errors_reconstr_pca')
            axs(1)=plot(median(errors_reconstr_pca,2),'d','Linewidth',2,'color','c');
            axs(2)=plot(median(errors_batch_pca,2),'+','Linewidth',2,'color','g');
%                 axs(3)=plot(median(errors_online,2),'*','Linewidth',2,'color',cols);
            axs(3)=plot(median(errors_similarity,2),'+','Linewidth',2,'color',[.8 .8 .8]);
            axs(4)=plot(median(errors_reconstr,2),'*','Linewidth',2,'color','y');
%                 legend(axs,{'real','batch pca','online'}, 'Interpreter', 'none')
            xlabel(fname)
            ylabel('Projection error')
            drawnow
        end
        hold all
        
        options_algorithm=struct();
        options_algorithm.pca_algorithm='CCIPCA';
        options_algorithm.q=options_generator.q;
        options_algorithm.tol=1e-7;
        [errors_real,errors_batch_pca,errors_online,errors_reconstr,errors_similarity,times_,fname]=Online_PCA_simulations(folder_exp,options_simulations,options_generator,options_algorithm);
        cla
        hold all
        if ~isempty(errors_real)
            axs=[];
            counter=counter+1;
            cols=cm(100,:);
            axs(1)=plot(0,0);
            load(fullfile(folder_exp,[fname '.mat']),'errors_reconstr_pca')
            axs(1)=plot(median(errors_reconstr_pca,2),'d','Linewidth',2,'color','b');
            axs(2)=plot(median(errors_batch_pca,2),'+','Linewidth',2,'color','m');
%                 axs(3)=plot(median(errors_online,2),'*','Linewidth',2,'color',cols);
            axs(3)=plot(median(errors_similarity,2),'+','Linewidth',2,'color','r');
            axs(4)=plot(median(errors_reconstr,2),'*','Linewidth',2,'color','k');
%                 legend(axs,{'real','batch pca','online'}, 'Interpreter', 'none')
            xlabel(fname)
            ylabel('Projection error')
            drawnow
        end
        
%         options_algorithm=struct();
%         options_algorithm.pca_algorithm='SEQ_SIM_PCA';
%         options_algorithm.q=options_generator.q;
%         options_algorithm.update_method='ls';
%         options_algorithm.tol=1e-5;
%         [errors_real,errors_batch_pca,errors_online,errors_reconstr,errors_similarity,times_,fname]=Online_PCA_simulations(folder_exp,options_simulations,options_generator,options_algorithm);
%         hold all
%         if ~isempty(errors_real)
%             axs=[];
%             counter=counter+1;
%             cols=cm(100,:);
%             axs(1)=plot(0,0);
%             load(fullfile(folder_exp,[fname '.mat']),'errors_reconstr_pca')
%             axs(1)=plot(median(errors_reconstr_pca,2),'d','Linewidth',2,'color','b');
%             axs(2)=plot(median(errors_batch_pca,2),'+','Linewidth',2,'color','m');
% %                 axs(3)=plot(median(errors_online,2),'*','Linewidth',2,'color',cols);
%             axs(3)=plot(median(errors_similarity,2),'+','Linewidth',2,'color','r');
%             axs(4)=plot(median(errors_reconstr,2),'*','Linewidth',2,'color','k');
% %                 legend(axs,{'real','batch pca','online'}, 'Interpreter', 'none')
%             xlabel(fname)
%             ylabel('Projection error')
%             drawnow
%         end
        
%         pause
%         cla
        
    end
end

%% ATT
options_generator=struct;
options_generator.method='ATT';%load YALE Data;
%
format compact
t = datetime('now');
folder_exp=['ATT_n0_' num2str(options_simulations.n0) '_niter' num2str(options_simulations.niter) '_' char(t)];
mkdir(folder_exp)
options_simulations.perc_samp_extra_test=.2;
options_generator.n=floor(400/(1+options_simulations.perc_samp_extra_test));
options_generator.d=10304;
%%
close
hold all
legends={};
cm=hot(220);
counter=0;

for q=[4 16 64 128 256]
    for norm_scale=[2*pi]
        options_generator.q=q;
        disp(q)
        options_simulations.normalization_scale=1;
        options_simulations.init_weight_mult=norm_scale;%10/q;

        
%         options_algorithm=struct();
%         options_algorithm.pca_algorithm='IPCA';
%         options_algorithm.q=options_generator.q;
%         options_algorithm.tol=1e-7;
%         [errors_real,errors_batch_pca,errors_online,errors_reconstr,errors_similarity,times_,fname]=Online_PCA_simulations(folder_exp,options_simulations,options_generator,options_algorithm);
%         hold all
%         if ~isempty(errors_real)
%             axs=[];
%             counter=counter+1;
%             cols=cm(100,:);
%             axs(1)=plot(0,0);
%             load(fullfile(folder_exp,[fname '.mat']),'errors_reconstr_pca')
%             axs(1)=plot(median(errors_reconstr_pca,2),'d','Linewidth',2,'color','b');
%             axs(2)=plot(median(errors_batch_pca,2),'+','Linewidth',2,'color','m');
% %                 axs(3)=plot(median(errors_online,2),'*','Linewidth',2,'color',cols);
%             axs(3)=plot(median(errors_similarity,2),'+','Linewidth',2,'color','r');
%             axs(4)=plot(median(errors_reconstr,2),'*','Linewidth',2,'color','k');
% %                 legend(axs,{'real','batch pca','online'}, 'Interpreter', 'none')
%             xlabel(fname)
%             ylabel('Projection error')
%             drawnow
%         end

        
        options_algorithm=struct();
        options_algorithm.pca_algorithm='H_AH_NN_PCA';
        options_algorithm.q=options_generator.q;
        options_algorithm.update_method='ls';
        options_algorithm.tol=1e-5;
        [errors_real,errors_batch_pca,errors_online,errors_reconstr,errors_similarity,times_,fname]=Online_PCA_simulations(folder_exp,options_simulations,options_generator,options_algorithm);
        if ~isempty(errors_real)
            axs=[];
            counter=counter+1;
            cols=cm(100,:);
            axs(1)=plot(0,0);
            load(fullfile(folder_exp,[fname '.mat']),'errors_reconstr_pca')
            axs(1)=plot(median(errors_reconstr_pca,2),'d','Linewidth',2,'color','c');
            axs(2)=plot(median(errors_batch_pca,2),'+','Linewidth',2,'color','g');
%                 axs(3)=plot(median(errors_online,2),'*','Linewidth',2,'color',cols);
            axs(3)=plot(median(errors_similarity,2),'+','Linewidth',2,'color',[.8 .8 .8]);
            axs(4)=plot(median(errors_reconstr,2),'*','Linewidth',2,'color','y');
%                 legend(axs,{'real','batch pca','online'}, 'Interpreter', 'none')
            xlabel(fname)
            ylabel('Projection error')
            drawnow
        end
        hold all
        
%         
        options_algorithm=struct();
        options_algorithm.pca_algorithm='SEQ_SIM_PCA';
        options_algorithm.q=options_generator.q;
        options_algorithm.update_method='ls';
        options_algorithm.tol=1e-5;
        [errors_real,errors_batch_pca,errors_online,errors_reconstr,errors_similarity,times_,fname]=Online_PCA_simulations(folder_exp,options_simulations,options_generator,options_algorithm);
        hold all
        if ~isempty(errors_real)
            axs=[];
            counter=counter+1;
            cols=cm(100,:);
            axs(1)=plot(0,0);
            load(fullfile(folder_exp,[fname '.mat']),'errors_reconstr_pca')
            axs(1)=plot(median(errors_reconstr_pca,2),'d','Linewidth',2,'color','b');
            axs(2)=plot(median(errors_batch_pca,2),'+','Linewidth',2,'color','m');
%                 axs(3)=plot(median(errors_online,2),'*','Linewidth',2,'color',cols);
            axs(3)=plot(median(errors_similarity,2),'+','Linewidth',2,'color','r');
            axs(4)=plot(median(errors_reconstr,2),'*','Linewidth',2,'color','k');
%                 legend(axs,{'real','batch pca','online'}, 'Interpreter', 'none')
            xlabel(fname)
            ylabel('Projection error')
            drawnow
        end
        
%         pause
%         cla
        
    end
end
%% time per cycle test
format compact
options_simulations.compute_error=0;
options_simulations.niter=10;
options_simulations.initialize_PCA=0;

t = datetime('now');
folder_exp=['n0_' num2str(options_simulations.n0) '_niter' num2str(options_simulations.niter) '_' char(t)];
mkdir(folder_exp)
hold all
legends={};
options_generator.n=400;
cm=hot(220);
counter=0;

for q=[4 16 32 64 128 256 512 1024]
    for d= [8192 8192*4]
        for rho=[.5]
            options_generator.q=q;
            options_generator.d=d;
            disp(rho)
            options_generator.rho=rho;
            
            
            %             options_algorithm=struct();
            %             options_algorithm.pca_algorithm='IPCA';
            %             options_algorithm.q=options_generator.q;
            %             options_algorithm.tol=1e-7;
            %             [errors_real,errors_batch_pca,errors_online,times_,fname]=Online_PCA_simulations(folder_exp,options_simulations,options_generator,options_algorithm);
            %             if ~isempty(errors_real)
            %                 axs=[];
            %                 counter=counter+1;
            %                 cols=cm(counter,:);
            %                 axs(1)=plot(median(errors_real,2),'d','Linewidth',2,'color',cols);
            %                 axs(2)=plot(median(errors_batch_pca,2),'+','Linewidth',2,'color',cols);
            %                 axs(3)=plot(median(errors_online,2),'*','Linewidth',2,'color',cols);
            %                 legend(axs,{'real','batch pca','online'}, 'Interpreter', 'none')
            %                 xlabel(fname)
            %                 ylabel('Projection error')
            %                 drawnow
            %             end
            
            options_algorithm=struct();
            options_algorithm.pca_algorithm='H_AH_NN_PCA';
            options_algorithm.q=options_generator.q;
            options_algorithm.update_method='ls';
            options_algorithm.tol=1e-5;
            
            %[errors_real,errors_batch_pca,errors_online,times_,fname]=Online_PCA_simulations(folder_exp,options_simulations,options_generator,options_algorithm);
            if ~isempty(errors_real)
                axs=[];
                counter=counter+1;
                cols=cm(counter,:);
                axs(1)=plot(median(errors_real,2),'d','Linewidth',2,'color',cols);
                axs(2)=plot(median(errors_batch_pca,2),'+','Linewidth',2,'color',cols);
                axs(3)=plot(median(errors_online,2),'*','Linewidth',2,'color',cols);
                legend(axs,{'real','batch pca','online'}, 'Interpreter', 'none')
                xlabel(fname)
                ylabel('Projection error')
                drawnow
            end
            
            %             options_algorithm=struct();
            %             options_algorithm.pca_algorithm='SGA';
            %             options_algorithm.method='SGA';
            %             options_algorithm.q=options_generator.q;
            %             options_algorithm.do_sort=1;
            %             options_algorithm.tol=1e-7;
            %
            %             [errors_real,errors_batch_pca,errors_online,times_,fname]=Online_PCA_simulations(folder_exp,options_simulations,options_generator,options_algorithm);
            %             if ~isempty(errors_real)
            %                 axs=[];
            %                 counter=counter+1;
            %                 cols=cm(counter,:);
            %                 axs(1)=plot(median(errors_real,2),'d','Linewidth',2,'color',cols);
            %                 axs(2)=plot(median(errors_batch_pca,2),'+','Linewidth',2,'color',cols);
            %                 axs(3)=plot(median(errors_online,2),'*','Linewidth',2,'color',cols);
            %                 legend(axs,{'real','batch pca','online'}, 'Interpreter', 'none')
            %                 xlabel(fname)
            %                 ylabel('Projection error')
            %                 drawnow
            %             end
        end
    end
end

%%
errors_paper=[];
errors_paper_half=[];
times_paper=[];
for rho=0:.1:1
    disp(rho)
    options_generator.rho=rho;
    options=struct();
    test_method='SGA';
    options.method=test_method;
    options.tol=1e-7;
    options.do_sort=1;
    [allerrors,alltimes,legends]=Online_PCA_simulations(q_each,num_samples_each,d_each,n0,niter,nstep_skip_EIGV_errors,test_method,options,options_generator,errors_paper,errors_paper_half,times_paper);
    %     uiwait
    %     cla
end


%% !!!! LEARNING RATE MANUALLY SET IN THE FILE!!!
% for rho=0:.1:1
%     disp(rho)
%     options_generator.rho=rho;
%
%     options=struct();
%     test_method='SGA';
%     options.method=test_method;
%     options.do_sort=1;
%     errors_paper=[ .025 .014 .016];
%     errors_paper_half=[0.031 .02 .021];
%
%     times_paper=[0.09 .16 .12];
%     [allerrors,alltimes,legends]=Online_PCA_simulations_1(q_each,num_samples_each,d_each,n0,niter,nstep_skip_EIGV_errors,test_method,options,options_generator,errors_paper,errors_paper_half,times_paper);
% end
% %% !!!! LEARNING RATE MANAULLY SET IN THE FILE
%
% options=struct();
% test_method='GHA';
% options.method=test_method;
% options.do_sort=1;
% errors_paper=[ .024 .014 .016];
% errors_paper_half=[0.03 .02 .023 ];
%
% times_paper=[0.06 .08 .09 ];
% [allerrors,alltimes,legends]=Online_PCA_simulations_1(q_each,num_samples_each,d_each,n0,niter,nstep_skip_EIGV_errors,test_method,options,options_generator,errors_paper,errors_paper_half,times_paper,learning_rates);
% close all