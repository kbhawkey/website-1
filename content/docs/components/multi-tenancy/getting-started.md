+++
title = "Getting Started with Multi-user Isolation"
description = "How to use multi-user isolation with profiles"
weight = 30
+++

{{% stable-status %}}

## Usage overview

After Kubeflow is installed and configured, you will by default
be accessing your *primary profile*. A *profile* owns a Kubernetes namespace of
the same name along with a collection of Kubernetes resources. Users have view
and modify access to their primary profiles. You can share
access to your profile with another user in the system. When sharing the access
to a profile with another user, you can choose to whether provide only read access or read/modify
access. For all practical purposes when working
through the Kubeflow central dashboard, the active namespace is directly tied
with the active profile.

## Example of usage

You can select your active profile from the top bar on the Kubeflow central
dashboard.  Note that you can only view the profiles in the dropdown list
to which you have view or modify access.

<img src="/docs/images/select-profile.png" 
  alt="Select active profile "
  class="mt-3 mb-3 border border-info rounded">

This guide illustrates the user isolation functionality using the Jupyter
notebooks service which is the first service in the system to have full
integration with the multi-user isolation functionality.  

Once an active profile has been selected, the Notebooks Servers UI
will display only the active notebook servers in the currently selected
profile. All other notebook servers remain hidden from you. If you switch
the active profile, the view will switch the list of active notebooks
appropriately. You can connect to any of the listed notebook servers and
view and modify the existing Jupyter notebooks available in the server.

For example, the following image shows the list of Notebook servers available
in a user's primary profile:

<img src="/docs/images/notebooks-in-profile.png" 
  alt="List of notebooks in active profile "
  class="mt-3 mb-3 border border-info rounded">

And when an unauthorized user accesses the Notebooks in this profile, they are
presented with an error.

<img src="/docs/images/notebook-access-error.png" 
  alt="Error listing notebooks in inacessible profile"
  class="mt-3 mb-3 border border-info rounded">

When you create Jupyter notebook servers from the Notebooks Servers UI,
the notebook pods are created in your active profile. If you don't have
modify access to the active profile, you can only browse currently active
notebook servers and access the existing jupyter notebooks but cannot create
new notebook servers in that profile. You can create notebook
servers in your primary profile which they have view and modify access to.

## Onboarding a new user

Kubeflow {{% kf-latest-version %}} provides automatic profile creation for authenticated users on
first login. Additionally, an **administrator** can create a profile for any
user in the kubeflow cluster.  Here an administrator is a person who has
[*cluster-admin*](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#user-facing-roles)
role binding in the Kubernetes cluster. This person has permissions to create
and modify Kubernetes resources in the cluster. For example, the person who
deployed Kubeflow will have administration privileges in the cluster.

### Pre-requisites: grant user minimal Kubernetes cluster view access

User should be given minimal permission scope that allows them to connect to the Kubernetes cluster.
For example for GCP users, they can be granted IAM roles: **Kubernetes Engine Cluster Viewer** and **IAP-secured Web App User**

### Automatic creation of profiles

Kubeflow {{% kf-latest-version %}} provides automatic profile creations as a convenience
to the users:

  - Kubeflow deployment process automatically creates a profile for the user
    performing the deployment. When the user access the Central Dashboard
    they'll already see their profile in the dropdown list.
  - When an authenticated user logs into the system and visits the Central
    Dashboard for the first time, they trigger a profile creation automaticlly.
      - A brief message introduces profiles <img
        src="/docs/images/auto-profile1.png" alt="Automatic profile creation
        step 1" class="mt-3 mb-3 border border-info rounded">
      - The user can name their profile and click *Finish*.  <img
        src="/docs/images/auto-profile2.png" alt="Automatic profile creation
        step 2" class="mt-3 mb-3 border border-info rounded">
      - This redirects the user to the dashboard where they can view and select
      thier profile in the dropdown list.

### Manual profile creation

An administrator can manually create profiles for users as described below.

Create a
`profile.yaml` file with the following contents on your local machine:

```
$ cat << EOF > profile.yaml
apiVersion: kubeflow.org/v1beta1
kind: Profile
metadata:
  name: profileName   # replace with the name of profile you want, this will be user's namespace name
spec:
  owner:
    kind: User
    name: userid@email.com   # replace with the email of the user
EOF
```
Create the corresponding profile resource using:

```
$ kubectl create -f profile.yaml
```

The above creates a profile named *profileName* whose owner is
*userid@email.com* and has view and modify access to that profile.
The following resources are created as part of the profile creation:

  - A Kubernetes namespace that shares the same name with the corresponding
    profile.
  - Kubernetes RBAC rolebinding for the namespace *Admin*. This makes the
    profile owner the namespace admin, allowing access to the namespace via
    Kubernetes API (using kubectl).
  - Istio namespace-scoped ServiceRole *ns-access-istio*. This allows access to
    all services in the target namespace via Istio routing.
  - Istio namespace-scoped ServiceRoleBinding *owner-binding-istio*. This binds
    the ServiceRole ns-access-istio to the profile owner. The profile owner can
    therefore access services in the namespace created.
  - Namespace-scoped service-accounts editor and viewer to be used by
    user-created pods in above namespace.


**Note**: Due to a 1-to-1 correspondence of Profiles with Kubernetes
Namespaces, Profiles and Namespaces are sometimes used interchangably in the
documentation.

### Batch creation of user profiles

Administrators might want to create profiles for multiple users as a batch. This can
be done by creating a `profile.yaml` on the local machine with multiple sections of
profile descriptions as shown below:

```
$ cat << EOF > profile.yaml
apiVersion: kubeflow.org/v1beta1
kind: Profile
metadata:
  name: profileName1   # replace with the name of profile you want
spec:
  owner:
    kind: User
    name: userid1@email.com   # replace with the email of the user
---
apiVersion: kubeflow.org/v1beta1
kind: Profile
metadata:
  name: profileName2   # replace with the name of profile you want
spec:
  owner:
    kind: User
    name: userid2@email.com   # replace with the email of the user
EOF
```

Apply to the Kubernetes cluster using:
```
kubectl create -f profile.yaml
```

This will create multiple profiles for each individual listed in the sections
in `profile.yaml`.

## Listing and describing profiles

An **administrator** can list the existing profiles in the system:
```
$ kubectl get profiles
```
and describe a specific profile using:
```
$ kubectl describe profile profileName
```

## Deleting an existing profile

An **administrator** can delete an existing profile using:
```
$ kubectl delete profile profileName
```

This will delete the profile, the corresponding namespace and any Kubernetes
resources associated with the profile. The profile's owner or other users with
access to the profile will no longer have access to the profile and will not see
it in the dropdown list on the central dashboard.


## Managing contributors through UI

Kubeflow {{% kf-latest-version %}} allows sharing of profiles with other users in the
system.  An owner of a profile can share access to their profile using the
*Manage Contributors* tab available through the dashboard.

<img src="/docs/images/multi-user-contributors.png" 
  alt="Manage Contributors in Profiles"
  class="mt-3 mb-3 border border-info rounded">

Here is an example of the Manage Contributors tab view:

<img src="/docs/images/manage-contributors.png" 
  alt="Manage Contributors in Profiles"
  class="mt-3 mb-3 border border-info rounded">

Notice that in the above view the account associated with the profile is
*Cluster Admin* as this account was used to deploy Kubeflow. It lists the
profiles accessible to the user along with the role associated with that
profile.

Adding and removing contributors is easily possible by simply adding/removing the 
email address or the user identifier in the *Contributors to your namespace* field.

<img src="/docs/images/add-contributors.png" 
  alt="Add Contributors"
  class="mt-3 mb-3 border border-info rounded">

Once added, the Manage Contributors tab will show the profiles with thier
corresponding contributors listed. Note that *Cluster Admin* can view all the 
profiles in the system along with their contributors.

<img src="/docs/images/view-contributors.png" 
  alt="View Contributors"
  class="mt-3 mb-3 border border-info rounded">


The contributors will have access to all the Kubernetes resources in the
namespace and will be able to created notebook servers as well as access
existing notebooks.  The contributor's access can be removed by the owner of a
profile by visiting the *Manage Contributors* tab and removing the user
email/id from the list of contributors.