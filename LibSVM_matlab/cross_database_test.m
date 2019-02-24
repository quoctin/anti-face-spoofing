%   Copyright (c) 2016-2018 Quoc-Tin Phan (quoctin.phan@unitn.it), Duc-Tien Dang-Nguyen and Giulia Boato
%   These code called functions from LibSVM, Copyright (c) 2000-2014 Chih-Chung Chang and Chih-Jen Lin

function cross_database_test(data_train_1, data_test_1, data_train_2, data_test_2)
%   The cross_database_test returns the results in terms of TPR at FAR = 0.1, of cross-database test by
%   conducting 4-fold validation: 
%   1. train on data_train_1 and test on data_train2
%   2. train on data_train_1 and test on data_test_2
%   3. train on data_test_1 and test on data_train_2
%   4. train on data_test_1 and test on data_test_2
%   data_train_1 is the filename of the file containing [labels, 1xd
%   histograms] of the training set on the dataset 1.
%   data_test_1 is the filename of the file containing [labels, 1xd
%   histograms] of the testing set on dataset 1.
%   data_train_2 is the filename of the file containing [labels, 1xd
%   histograms] of the training set on the dataset 2.
%   data_test_2 is the filename of the file containing [labels, 1xd
%   histograms] of the testing set on the dataset 2.
%   label = 1 for attacks, -1 for real access. We will reverse them later.

    data_train_1 = csvread(data_train_1);
    labels_train_1 = data_train_1(:,1);
    labels_train_1 = -1 * labels_train_1;  %we assigned 1 for attack, -1 for real. Now we reverse these values
    features_train_1 = data_train_1(:,2:end);
    features_sparse_train_1 = sparse(features_train_1);
    
    data_test_1 = csvread(data_test_1);
    labels_test_1 = data_test_1(:,1);
    labels_test_1 = -1 * labels_test_1; %we assigned 1 for attack, -1 for real. Now we reverse these values
    features_test_1 = data_test_1(:,2:end);
    features_sparse_test_1 = sparse(features_test_1);
    
    data_train_2 = csvread(data_train_2);
    labels_train_2 = data_train_2(:,1);
    labels_train_2 = -1 * labels_train_2; %we assigned 1 for attack, -1 for real. Now we reverse these values
    features_train_2 = data_train_2(:,2:end);
    features_sparse_train_2 = sparse(features_train_2);
    
    data_test_2 = csvread(data_test_2);
    labels_test_2 = data_test_2(:,1);
    labels_test_2 = -1 * labels_test_2; %we assigned 1 for attack, -1 for real. Now we reverse these values
    features_test_2 = data_test_2(:,2:end);
    features_sparse_test_2 = sparse(features_test_2);
    
    all_TPR_01 = [];
    
    model = svmtrain(labels_train_1, features_sparse_train_1, '-b 1 -q 1');
    [predicted_label, accuracy, decision_values] = svmpredict(labels_train_2, features_sparse_train_2, model, '-b 1 -q 1');
    
    TPR_01 = statistics_tpr(labels_train_2, predicted_label, decision_values);
    all_TPR_01 = [all_TPR_01, TPR_01];
    
    model = svmtrain(labels_train_1, features_sparse_train_1, '-b 1 -q 1');
    [predicted_label, accuracy, decision_values] = svmpredict(labels_test_2, features_sparse_test_2, model, '-b 1 -q 1');
    
    TPR_01 = statistics_tpr(labels_test_2, predicted_label, decision_values);
    all_TPR_01 = [all_TPR_01, TPR_01];
    
    model = svmtrain(labels_test_1, features_sparse_test_1, '-b 1 -q 1');
    [predicted_label, accuracy, decision_values] = svmpredict(labels_train_2, features_sparse_train_2, model, '-b 1 -q 1');
    
    TPR_01 = statistics_tpr(labels_train_2, predicted_label, decision_values);
    all_TPR_01 = [all_TPR_01, TPR_01];

    model = svmtrain(labels_test_1, features_sparse_test_1, '-b 1 -q 1');
    [predicted_label, accuracy, decision_values] = svmpredict(labels_test_2, features_sparse_test_2, model, '-b 1 -q 1');
    
    TPR_01 = statistics_tpr(labels_test_2, predicted_label, decision_values);
    all_TPR_01 = [all_TPR_01, TPR_01];
    
    actual_TPR_01 = mean(all_TPR_01);
    
    fprintf('TPR 01 = %.4f\n', actual_TPR_01);
end

function [TPR_01] = statistics_tpr(real_labels, predicted_labels, decision_values)

    
    [FPR, TPR, Thr, AUC, OPTROCPT] = perfcurve(real_labels, decision_values(:,1), 1);
    %calculating TPR with FAR = 0.1
    FPR = round(FPR, 10);
    TPR = round(TPR, 10);
    FAR = FPR;
    
    [m, ind] = min(abs(FAR - 0.1));
    TPR_01 = TPR(ind);
end

