Vagrant.configure("2") do |config|
	
	config.vm.box = "trusty64"
	config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"

	config.vm.hostname = "rabbitmq.example.local"

	config.vm.network :forwarded_port, guest: 15672, host: 15672
	
	config.vm.provider :virtualbox do |virtualbox|
		virtualbox.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
		virtualbox.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
		virtualbox.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
	end
	
	config.vm.provision :puppet do |puppet|
		puppet.options = ["--fileserverconfig=/vagrant/env/puppet/fileserver.conf"]
		puppet.manifests_path = "env/puppet/manifests"
		puppet.manifest_file = "default.pp"
		puppet.module_path = "env/puppet/modules"
	end
end
