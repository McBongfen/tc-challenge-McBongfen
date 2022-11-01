node ('master'){

    stage('checkout scm'){
        git branch: 'main', credentialsId: 'uturnid', url: 'https://github.com/uturndata-public/tech-challenge-flask-app.git'
    }
    
    stage('deploying code'){
        sshPublisher(publishers: [sshPublisherDesc(configName: 'instance-1', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'pip install -r requirements.txt ', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '/home/ubuntu', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '**/*')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
        sshPublisher(publishers: [sshPublisherDesc(configName: 'instance-2', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'pip install -r requirements.txt ', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '/home/ubuntu', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '**/*')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
    }    
    
}
