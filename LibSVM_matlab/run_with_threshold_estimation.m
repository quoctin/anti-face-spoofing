%   Copyright (c) 2016-2018 Quoc-Tin Phan (quoctin.phan@unitn.it), Duc-Tien Dang-Nguyen and Giulia Boato
%   These code called functions from LibSVM, Copyright (c) 2000-2014 Chih-Chung Chang and Chih-Jen Lin

function run_with_threshold_estimation(data_train, data_test, data_devel)
%   function run_with_threshold_estimation returns the prediction performance
%   in terms of FRR, FAR, HTER, Accuracy and EER.
%   data_train is the filename of the file containing [labels, 1xd
%   histograms] of the training set.
%   data_test is the filename of the file containing [labels, 1xd
%   histograms] of the testing set.
%   data_devel is the filename of the file containing [labels, 1xd
%   histograms] of the development set.
%   label = 1 for attacks, -1 for real access. We will reverse them later.


    data_train = csvread(data_train);
    labels_train = data_train(:,1);
    features_train = data_train(:,2:end);
    features_sparse_train = sparse(features_train);
    
    
    data_test = csvread(data_test);
    labels_test = data_test(:,1);
    features_test = data_test(:,2:end);
    features_sparse_test = sparse(features_test);
    
    %we assigned 1 for attack, -1 for real. Now we reverse these values
    labels_train = -1 * labels_train;
    labels_test = -1 * labels_test;
    
    % If data_devel is available
    
    model = svmtrain(labels_train, features_sparse_train, ' -b 1 -q');
    
    if exist('data_devel', 'var')  
        
        data_devel = csvread(data_devel);
        labels_devel = data_devel(:,1);
        features_devel = data_devel(:,2:end);
        features_sparse_devel = sparse(features_devel);
        
        %we assigned 1 for attack, -1 for real. Now we reverse these values
        labels_devel = -1 * labels_devel;
        
        %estimating the threshold
        [predicted_label, accuracy, decision_values] = svmpredict(labels_devel, features_sparse_devel, model, '-b 1 -q');
        
        [FPR, TPR, Thr, AUC, OPTROCPT] = perfcurve(labels_devel, decision_values(:,1), 1);
        
        OPTROCPT = round(OPTROCPT, 10);
        FPR = round(FPR, 10);
        TPR = round(TPR, 10);
        
        FRR = round(1 - TPR,10);
        FAR = FPR;
        
        [minD, ind] = min(abs(FAR - FRR));
        
        desired_threshold = Thr(ind);
        
        %classifying the test set
        [predicted_label, accuracy, decision_values] = svmpredict(labels_test, features_sparse_test, model, '-b 1 -q');       
        
        %calibrate the result with the desired threshold        
        predicted_label = (decision_values(:,1) >= desired_threshold);
        predicted_label = -1*(predicted_label == 0) + predicted_label;
        
        
    else        
        %classifying the test set
        [predicted_label, accuracy, decision_values] = svmpredict(labels_test, features_sparse_test, model, '-b 1 -q');
    end
    
    %calculating FRR: 1 ==> -1
    FRR = sum((labels_test - predicted_label) == 2)*100 / sum(labels_test == 1);
    fprintf('\nFRR = %.2f', FRR);
    
    %calculating FAR: -1 ==> 1   
    FAR = sum((predicted_label - labels_test) == 2)*100 / sum(labels_test == -1);
    fprintf('\nFAR = %.2f', FAR);
        
    %calculating HTER
    HTER = (FAR + FRR) / 2;
    fprintf('\nHTER = %.2f', HTER);
    
    %calculating accuracy
    acc = 100 - (sum(predicted_label ~= labels_test))*100 / length(predicted_label);
    fprintf('\nAcc = %.2f\n', acc);
    
    %calculating EER
    [FPR, TPR, Thr, AUC, OPTROCPT] = perfcurve(labels_test, decision_values(:,1), 1);

    FPR = round(FPR, 10);
    TPR = round(TPR, 10);

    FRR = round(1 - TPR,10);
    FAR = FPR;
    minD = 2; flag = 1;
    
    [minD, ind] = min(abs(FAR - FRR));
    EER = FAR(ind);
    
    fprintf('\nEER = %.4f\n', EER);
    
end