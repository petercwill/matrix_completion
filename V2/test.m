rng(1234);
%dims = [20,30,40,50,60,70,80,90,100];
%SRs = [.1, .2, .3, .4, .5, .6, .7, .8, .9];
dims = [80];
SRs = [.1, .2, .3, .4, .5, .6, .7, .8, .9];
ranks = [.5]; 
noises = [1,2,3,4,5,6,7,8,9];
[mesh_x, mesh_y] = meshgrid(noises, SRs); 
mesh_z = zeros(size(mesh_x));
error_mesh_z = zeros(size(mesh_x));
for d_idx = 1:length(noises)
    for SR_idx = 1:length(SRs)
        for r_idx = 1:length(ranks)
            %m = dims(d_idx);
            %n = dims(d_idx);
            % r = ceil(ranks(r_idx)*dims(d_idx));
            %r = 10;
            r = 8;
            m = 80;
            n = 80;
            noise = noises(d_idx);
            SR = SRs(SR_idx);
            fprintf('Noise: %d, SR: %d, Rank: %d\n',noises(d_idx), SR,r);
            [M, inds, delta] = gen_data(m,n,r,SR, noise);
            [X_hat, itr, time, val] = ADM(M,inds,delta);
            %cvx_string = evalc('cvx_solver(M,inds,delta);');
            %[cvx_itr, cvx_time, cvx_val] = parse_output(cvx_string);
            %fprintf('Iter: %d, Cvx_Iter: %d\n',itr, cvx_itr);
            %fprintf('Time: %d, Cvx_Time: %d\n',time, cvx_time);
            %fprintf('Val: %d, Cvx_Val: %d\n',val, cvx_val);
            mesh_z(SR_idx,d_idx) = cvx_time / time;
            error_mesh_z(SR_idx,d_idx) = cvx_val / val;
        end
    end
end
figure1 = figure;
axes1 = axes('Parent',figure1);
surf(axes1, mesh_x, mesh_y, mesh_z);
%zlim(axes1,[0 3]);
xlabel('Noise');
ylabel('Sample Ratio');
zlabel('Relative Speedup');
set(gca, 'ZScale', 'log')

% hold(axes1,'off');
% 
figure2 = figure;
axes2 = axes('Parent',figure2);
%hold(axes2,'on');
surf(axes2, mesh_x, mesh_y, error_mesh_z);
xlabel('Noise');
ylabel('Sample Ratio');
zlabel('Relative Error');
set(gca, 'ZScale', 'log')


