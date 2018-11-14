function B = sobi(X)
% Copyright : Jean-Francois Cardoso.  cardoso@sig.enst.fr

n = size(X, 1);    % number of mixtures
T = size(X, 2);    % number of (time?) samples
m = n;             % number of sources
nbcm = min(10,ceil(T/3));  % number of correlation matrices 


% % ====================== Mean removal =======================
X = X - mean(X')' * ones(1,T);

% ======= Whitening & projection onto signal subspace =======
[U,D]  = eig((X*X')/T); % An eigen basis for the sample covariance matrix
[Ds,k] = sort(diag(D)); % Sort by increasing variances
PCs    = n:-1:n-m+1;    % The m most significant princip. comp. by decreasing variance

B      = U(:,k(PCs))';  % PCA 
scales = sqrt(Ds(PCs)); % Scaling 
B      = diag(1./scales)*B ;
X      = B*X;           % Sphering 

clear U D Ds k PCs scales;
 
% ========== Estimation of the correlation matrices ==========
for i=1:nbcm 
    tau = i-1;
    R=1/(T-tau)*( X(:,1:T-tau)*X(:,tau+1:T)' ); 
    m1=sum(X(:,1:T-tau),2)/(T-tau); 
    m2=sum(X(:,tau+1:T),2)/(T-tau);
    C=R-m1*m2'; 
    ii=(i-1)*m+1:i*m; 
    M(:,ii)=0.5*(C+C');
end 

% ====== Joint diagonalization of the cumulant matrices ======
[V,~] = joint_diag(M);

% A separating matrix
B = V'*B ;
% B = V';

% Permut the rows of the separating matrix B to get the most energetic 
% components first. Here the **signals** are normalized to unit variance.  
% Therefore, the sort is according to the norm of the columns of A = pinv(B)
A = pinv(B);
[~,keys] = sort(sum(A.*A));
B = B(keys,:);
B = B(m:-1:1,:); % Is this smart ?

% Signs are fixed by forcing the first column of B to have non-negative entries.
b = B(:,1);
signs = sign(sign(b)+0.1); % just a trick to deal with sign=0
B = diag(signs)*B;
end