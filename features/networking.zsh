
myip() {
	drill -Q myip.opendns.com @resolver1.opendns.com
}

prod() {
  sshuttle -r "bastion" -e 'gcloud compute ssh --zone "europe-west1-b" --tunnel-through-iap --project "tradera-prod-compute"' 172.20.0.2/32
}

prod-cdn() {
  # echo -n Password: 
  # read -s password
  sshuttle -r "bastion" -e 'gcloud compute ssh --zone "europe-west1-b" --tunnel-through-iap --project "tradera-prod-cdn"' 172.22.0.2/32
}

dev_dw() {
  sshuttle -r "bastion" -e 'gcloud compute ssh --zone "europe-west1-b" --tunnel-through-iap --project "tradera-prod-compute"' 172.16.8.2/32
}

prod-test() {
  sshuttle -r "bastion" -e 'gcloud compute ssh --zone "europe-west1-b" --tunnel-through-iap --project "tradera-prod-compute"' 172.20.0.18/32
}
