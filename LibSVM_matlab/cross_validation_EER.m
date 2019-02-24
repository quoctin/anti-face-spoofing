%   Copyright (c) 2016-2018 Quoc-Tin Phan (quoctin.phan@unitn.it), Duc-Tien Dang-Nguyen and Giulia Boato
%   These code called functions from LibSVM, Copyright (c) 2000-2014 Chih-Chung Chang and Chih-Jen Lin

function cross_validation_EER(data_train, data_test)
%   The cross_validation returns the prediction performance in terms of
%   FRR, FAR, HTER, Accuracy and EER by conducting 5-fold cross-validation.
%   data_train is the filename of the file containing [labels, 1xd
%   histograms] of the training set.
%   data_test is the filename of the file containing [labels, 1xd
%   histograms] of the testing set.
%   label = 1 for attacks, -1 for real access. We will reverse them later. 
    
    data_train = csvread(data_train);
    labels_train = data_train(:,1);
    features_train = data_train(:,2:end);
    features_sparse_train = sparse(features_train);
    
    data_test = csvread(data_test);
    labels_test = data_test(:,1);
    features_test = data_test(:,2:end);
    features_sparse_test = sparse(features_test);
    
    labels_train = [labels_train; labels_test];
    
    %we assigned 1 for attack, -1 for real. Now we reverse these values
    labels_train = -1 * labels_train;
    
    features_sparse_train = [features_sparse_train; features_sparse_test];
    [r,c] = size(features_sparse_train);
    
    all_FRR = [];
    all_FAR = [];
    all_HTER = [];
    all_EER = [];
    all_ACC = [];
    
    rand_rows = randperm(r)';
    % randomize features_sparse_train
    random_features_sparse_train = zeros(r,c);
    random_labels_train = zeros(r, 1);
    
    for i = 1:length(rand_rows)
        random_features_sparse_train(i,:) = features_sparse_train(rand_rows(i),:);
        random_labels_train(i,:) = labels_train(rand_rows(i),:);
    end
    
    clear features_sparse_train data_train labels_train features_train;
    clear features_sparse_test data_test labels_test features_test; 
    
    
    test_ranges = [1, floor(r/5)+1, floor(2*r/5)+1, floor(3*r/5) + 1, floor(4*r/5) + 1];
    
    for iter = 1:5
        
        folded_data = random_features_sparse_train;
        folded_labels = random_labels_train;
        
        train_subset = [];
        train_labels_subset = [];
        test_subset = [];
        test_labels_subset = [];
        
        test_length = floor(r / 5);
        
        test_subset = [test_subset; folded_data(test_ranges(iter):test_ranges(iter)+test_length - 1, :)];
        test_labels_subset = [test_labels_subset; folded_labels(test_ranges(iter):test_ranges(iter)+test_length - 1, :)];
        
        folded_data(test_ranges(iter):test_ranges(iter)+test_length - 1, :) = [];
        folded_labels(test_ranges(iter):test_ranges(iter)+test_length - 1, :) = [];
        
        train_subset = folded_data;
        train_labels_subset = folded_labels;
                
        model = svmtrain(train_labels_subset, train_subset, '-b 1 -q 1');
        [predicted_label, accuracy, decision_values] = svmpredict(test_labels_subset, test_subset, model, '-b 1 -q 1');
              
        
        %calculating FRR: 1 ==> -1
        FRR = sum((test_labels_subset - predicted_label) == 2)*100 / sum(test_labels_subset == 1);
        all_FRR = [all_FRR, FRR];
        

        %calculating FAR: -1 ==> 1   
        FAR = sum((predicted_label - test_labels_subset) == 2)*100 / sum(test_labels_subset == -1);
        all_FAR = [all_FAR, FAR];
        

        %calculating HTER
        HTER = (FAR + FRR) / 2;
        all_HTER = [all_HTER, HTER];
        

        %calculating EER
        [FPR, TPR, Thr, AUC, OPTROCPT] = perfcurve(test_labels_subset, decision_values(:,1), 1);

        FPR = round(FPR, 10);
        TPR = round(TPR, 10);

        FRR = round(1 - TPR,10);
        FAR = FPR;
        
        [minD, ind] = min(abs(FAR - FRR));
        EER = FAR(ind);
        
        all_EER = [all_EER, EER];
        
        %calculating accuracy
        acc = 100 - (sum(predicted_label ~= test_labels_subset))*100 / length(predicted_label);
        all_ACC = [all_ACC, acc];
        
        
    end
    
    fprintf('\nFRR = %.2f', mean(all_FRR));
    fprintf('\nFAR = %.2f', mean(all_FAR));
    fprintf('\nHTER = %.2f', mean(all_HTER));    
    fprintf('\nAcc = %.2f', mean(all_ACC));
    fprintf('\nEER = %f\n', mean(all_EER));

end

