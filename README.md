# Online Labs Rubygem

Easy to use Online Labs api client.

## Installation

Manual instalation:

	gem install onlinelabs

add this to your gemfile:

	gem 'onlinelabs'


## Usage

### Configure the client

    require 'onlinelabs'

	OnlineLabs.organization = <organization_key>
	OnlineLabs.token = <token>

### Servers

	# list all servers
	OnlineLabs::Server.all

	# list with filter
	OnlineLabs::Server.all state: :running

	# create a new server with default values
	OnlineLabs::Server.create

	# create a new server with name and tags
	OnlineLabs::Server.create :name => 'my_new_server', tags: ['prod']

	# get a server by id
    server = OnlineLabs::Server.find <server_id>

	# edit a server
    server = OnlineLabs::Server.find <server_id>
	server.name = 'new_name'
	OnlineLabs::Server.edit server.id, server

	# actions on a server
	OnlineLabs::Server.power_on server.id

	OnlineLabs::Server.power_off server.id

	OnlineLabs::Server.terminate server.id

	# destroy a server
	OnlineLabs::Server.destroy server.id

### Images

	# list all images
	OnlineLabs::Image.all

	# list marketplace images
	OnlineLabs::Image.marketplace

	# get image by id
	image = OnlineLabs::Image.find <image_id>

	# get image by name
	image = OnlineLabs::Image.find_by_name('Ubuntu')

	# create an image
	image = OnlineLabs::Image.create root_volume: snapshot

	# edit an image
	image = OnlineLabs::Image.edit id, image

	# destroy an image
	image = OnlineLabs::Image.destroy id

### Volumes

	# list all volumes
	OnlineLabs::Volume.all

	# get volume by id
	volume = OnlineLabs::Volume.find <volume_id>

	# create an volume
	volume = OnlineLabs::Volume.create
	volume = OnlineLabs::Volume.create size: 100 * 10 ** 9, volume_type: 'l_ssd'

	# edit an volume
	volume = OnlineLabs::Volume.edit id, volume

	# destroy an volume
	volume = OnlineLabs::Volume.destroy id

### Snapshots

	# list all snapshots
	OnlineLabs::Volume.all

	# get snapshot by id
	snapshot = OnlineLabs::Snapshot.find <snapshot_id>

	# create an snapshot
	snapshot = OnlineLabs::Snapshot.create volume_id: id

	# edit an snapshot
	snapshot = OnlineLabs::Snapshot.edit id, snapshot

	# destroy an snapshot
	snapshot = OnlineLabs::Snapshot.destroy id

### Ip addresses

	# list all ip addresses
	OnlineLabs::Ip.all

	# get Ip
	ip = OnlineLabs::Ip.find <ip_id>
	ip = OnlineLabs::Ip.find 127.0.0.1

	# reserve an ip
	ip = OnlineLabs::Ip.reserve
	# or
	ip = OnlineLabs::Ip.create

	# edit an ip
	ip = OnlineLabs::Ip.edit id, ip

	# release an ip
	ip = OnlineLabs::Ip.destroy id

### Handle exceptions

	# Not found
	begin
		puts OnlineLabs::Server.find <invalid_id>
	rescue OnlineLabs::NotFound => e
		# handle error here
	end

	# Other
	begin
		puts OnlineLabs::Server.create extra_field: ['nope']
	rescue OnlineLabs::APIError => e
		# handle error here
	end

## Example

    require 'onlinelabs'

	OnlineLabs.organization = <organization_key>
	OnlineLabs.token = <token>

	# get the docker image
	image = OnlineLabs::Image.find_by_name('Docker')

	# create 5 new servers
	5.times do |x|
		OnlineLabs::Server.create name: "docker#{x}', image: image.id, tags: ['docker']
	end

	# power on
	OnlineLabs::Server.all.each do |server|
		OnlineLabs::Server.power_on(server.id)
	end

	# do something ...

	# terminate
	OnlineLabs::Server.all.each do |server|
		OnlineLabs::Server.terminate(server.id)
	end
