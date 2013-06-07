module TestFixtures

  include RedStack::Identity::Models

  def self.load!
    # TODO
  end
  
  def self.users
    {
      admin: {
        name: 'an_admin',
        email: 'anadminuser@gmail.com',
        enabled: true,
        password: 'passwordz'
      },
      non_admin: {
        name: 'not_admin',
        email: 'notadmin@gmail.com',
        enabled: true,
        password: 'passwordz'
      }
    }
  end

  def self.projects
    {
      admin_project: {
        name: 'Admin Project',
        enabled: true
      },
      non_admin_project: {
        name: 'Non Admin Project',
        enabled: true
      }
    }
  end
  
end