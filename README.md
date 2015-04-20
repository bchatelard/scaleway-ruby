# Scaleway Rubygem

Easy to use Scaleway api client.

## Installation

Manual instalation:

	gem install scaleway

add this to your gemfile:

	gem 'scaleway'


## Usage

### Configure the client

    require 'scaleway'

	Scaleway.organization = <organization_key>
	Scaleway.token = <token>

### Servers

	# list all servers
	Scaleway::Server.all

	# list with filter
	Scaleway::Server.all state: :running

	# create a new server with default values
	Scaleway::Server.create

	# create a new server with name and tags
	Scaleway::Server.create :name => 'my_new_server', tags: ['prod']

	# get a server by id
    server = Scaleway::Server.find <server_id>

	# edit a server
    server = Scaleway::Server.find <server_id>
	server.name = 'new_name'
	Scaleway::Server.edit server.id, server

	# actions on a server
	Scaleway::Server.power_on server.id

	Scaleway::Server.power_off server.id

	Scaleway::Server.terminate server.id

	# destroy a server
	Scaleway::Server.destroy server.id

### Images

	# list all images
	Scaleway::Image.all

	# list marketplace images
	Scaleway::Image.marketplace

	# get image by id
	image = Scaleway::Image.find <image_id>

	# get image by name
	image = Scaleway::Image.find_by_name('Ubuntu')

	# create an image
	image = Scaleway::Image.create root_volume: snapshot

	# edit an image
	image = Scaleway::Image.edit id, image

	# destroy an image
	image = Scaleway::Image.destroy id

### Volumes

	# list all volumes
	Scaleway::Volume.all

	# get volume by id
	volume = Scaleway::Volume.find <volume_id>

	# create an volume
	volume = Scaleway::Volume.create
	volume = Scaleway::Volume.create size: 100 * 10 ** 9, volume_type: 'l_ssd'

	# edit an volume
	volume = Scaleway::Volume.edit id, volume

	# destroy an volume
	volume = Scaleway::Volume.destroy id

### Snapshots

	# list all snapshots
	Scaleway::Volume.all

	# get snapshot by id
	snapshot = Scaleway::Snapshot.find <snapshot_id>

	# create an snapshot
	snapshot = Scaleway::Snapshot.create volume_id: id

	# edit an snapshot
	snapshot = Scaleway::Snapshot.edit id, snapshot

	# destroy an snapshot
	snapshot = Scaleway::Snapshot.destroy id

### Ip addresses

	# list all ip addresses
	Scaleway::Ip.all

	# get Ip
	ip = Scaleway::Ip.find <ip_id>
	ip = Scaleway::Ip.find 127.0.0.1

	# reserve an ip
	ip = Scaleway::Ip.reserve
	# or
	ip = Scaleway::Ip.create

	# edit an ip
	ip = Scaleway::Ip.edit id, ip

	# release an ip
	ip = Scaleway::Ip.destroy id

### Handle exceptions

	# Not found
	begin
		puts Scaleway::Server.find <invalid_id>
	rescue Scaleway::NotFound => e
		# handle error here
	end

	# Other
	begin
		puts Scaleway::Server.create extra_field: ['nope']
	rescue Scaleway::APIError => e
		# handle error here
	end

## Example

    require 'scaleway'

	Scaleway.organization = <organization_key>
	Scaleway.token = <token>

	# get the docker image
	image = Scaleway::Image.find_by_name('Docker')

	# create 5 new servers
	5.times do |x|
		Scaleway::Server.create name: "docker#{x}", image: image.id, tags: ['docker']
	end

	# power on
	Scaleway::Server.all.each do |server|
		Scaleway::Server.power_on(server.id)
	end

	# do something ...

	# terminate
	Scaleway::Server.all.each do |server|
		Scaleway::Server.terminate(server.id)
	end
