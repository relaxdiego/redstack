module TestFixtures
  
  def self.users
    {
      admin: {
        username: 'an_admin',
        email: 'anadminuser@gmail.com',
        enabled: true,
        password: 'passwordz'
      },
      non_admin: {
        username: 'not_admin',
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