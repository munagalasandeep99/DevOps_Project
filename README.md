
# Ericsson Task



### Task 1: Build a Kubernetes Cluster.
- Open www.skyscanner.net
- Give origin as "Stockholm" and destination as "Everywhere" (Överallt in Swedish)
- Choose travel dates 22 Dec 2023 and return date 06 Jan 2024 and 1 adult as passenger.
- Search for flights
- Click on the first entry and see the lowest price shown there is same as the lowest price shown when clicked on the link.
- For ex : if it shows 500 SEK for Gothenburg as cheapest as first link, when clicked on the link it should show same 500 SEK as cheapest. If it shows different price, then the test case should be failed. Otherwise it should show as passed.

You can choose any open source testing tool of your choice. For Ex : selenium, playwright, webdriverIO etc

<p>Approach:</p>

### Task 2: Deploy a Sample Application
- The sample application is a todo application developed using React for front end, Node.js for Backend ad mongodb as database
- Now from the work station clone the repository using the command
```Shell
https://github.com/munagalasandeep99/ericcson-task.git
cd ericcson/Kubernetes-Manifests-file
kubectl create -f . 
```
```Shell
cd Frontend
kubectl create -f . 
```
```Shell
cd ../Database
kubectl create -f . 
```
```Shell
cd ../Backend
kubectl create -f . 
```

## deliverables
<h>Application code and kubernetes manifests</h>: the applcation code is present in Application_code file and Kubernetes-Manifests-file repectively above

<h>video</h> href="https://drive.google.com/file/d/130-2luUJOdhsTmaNA7UzeeI31t-fUfyh/view?usp=sharing"
