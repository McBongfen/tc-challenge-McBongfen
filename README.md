# tc-challenge-McBongfen

* This project is about Deploying Resources on AWS using IaC, Terraform and then deploying a Jenkins CI/CD pipeline.

## Infrastructure as Code (terraform)

* Install AWSCli and configure access and secret key of AWS.
```
aws configure
```

* Go inside terraform directory and initailize the code

```
terraform init
```

* Run below command to build infrastructure
```
terraform apply --auto-approve
```
* for destroying infrastructure
 ```
 terraform destroy --auto-approve
 ```

## CI/CD

Configure jenkins server and create pipeline with help of below script.

```
node ('master'){

    stage('checkout scm'){
        git branch: 'main', credentialsId: 'uturnid', url: 'https://github.com/uturndata-public/tech-challenge-flask-app.git'
    }
    
    stage('deploying code'){
        sshPublisher(publishers: [sshPublisherDesc(configName: 'instance-1', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'pip install -r requirements.txt ', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '/home/ubuntu', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '**/*')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
        sshPublisher(publishers: [sshPublisherDesc(configName: 'instance-2', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'pip install -r requirements.txt ', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '/home/ubuntu', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '**/*')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
    }    
    
}
```

## Testing

* Go on the below mentioned url and hit with routes which are mentioned in [tech-challenge-flask-app](https://github.com/uturndata-public/tech-challenge-flask-app)

```
http://3.143.214.105:8000/
```

## Routes

- [GET] /gtg
  - Simple healthcheck - returns HTTP 200 OK if everything is working
  - Empty return

- [GET] /gtg?details
  - Advanced healthcheck - returns HTTP 200 OK if everything is working and some service details
  - JSON return

- [POST] /candidate/<str:name>
  - Adds a new string (candidate name) to a list, returns HTTP 200 OK if working
  - JSON return

  - optional parameter ?party=
  - will assign to a political party
    - empty/unsupplied or ind: none/independent (default)
    - dem: democratic
    - rep: republican
  - will error if supplied with something other than the three parameters above

- [GET] /candidate/<str:name>
  - Gets candidate name from the list, returns HTTP 200 OK and data
  - JSON return

- [GET] /candidates
  - Gets list of all candidates from a list, returns HTTP 200 OK and data
  - JSON return
