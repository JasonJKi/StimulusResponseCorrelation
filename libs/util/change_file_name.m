close all; clc

% inpt data path
dataDir = 'data\'
subjFoldersDir = dir([dataDir '\0*'])
conditions = {
    'PLAY'
    'WATCH'
    'BCI'
    'KEYBOARD'
    };
conditionsNew = {
    'play'
    'watch'
    'bci'
    'keyboard'
};

fileTypes = {
    'XDF'
    'AVI'
    'MAT'
}

fileTypeNew = {
    'xdf'
    'avi'
    'mat'
}

for i = 20:length(subjFoldersDir)
    subjectNum = subjFoldersDir(i).name;
    for ii = 1:length(conditions)
        oldFolderName = conditions{ii};
        newFolderName = conditionsNew{ii};
        folderPath = [dataDir subjectNum '\'];
        if exist([folderPath  oldFolderName]) == 7
            for iii = 1:length(fileTypes)
              
                oldFolderName_ = fileTypes{iii};
                newFolderName_ = fileTypeNew{iii};
                if exist([folderPath  oldFolderName '\' oldFolderName_]) == 7
                    disp([' folder exists for subject ' oldFolderName_])
                    cd(['D:\ARL\' folderPath oldFolderName])
                    if newFolderName_ == 'avi'
                        mkdir('avi/downsampled/')
                    end
                    system(['rename ' oldFolderName_ ' ' newFolderName_]);
                else
                    cd(['D:\ARL\' folderPath oldFolderName])
                    mkdir(newFolderName_);
                end                            
                cd('D:\ARL\')                
            end
            cd(['D:\ARL\' folderPath])
            disp([conditions{ii} ' folder exists for subject ' subjectNum])
            system(['rename ' oldFolderName ' ' newFolderName]);
        end
        cd('D:\ARL\')
    end
end
        