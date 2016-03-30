# == Class teleport::service
#
# This class is meant to be called from teleport::init
# It ensure the service is running
#
class teleport::service {

	if $teleport::manage_service == true and $teleport::init_style {
		service { 'teleport':
			ensure     => $teleport::service_ensure,
			enable     => $teleport::service_enable,
			provider   => $teleport::init_style,
		}
	}
}
