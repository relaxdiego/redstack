require 'test_helper'

class IdentityProjectTests < MiniTest::Spec

  include RedStack::Identity::Models
  include CommonTestHelperMethods

  # Helper methods specific to these tests

  def new_attributes
    {
      name:         'REDSTACK_CREATED_PROJECT_FOR_TESTING',
      description:  'This is a project generated by RedStack',
      enabled:      true
    }
  end

  def updated_attributes
    {
      name:         'REDSTACK_UPDATE_PROJECT_TEST',
      description:  'This is a project updated by RedStack',
      enabled:      false
    }
  end

  # Tests

  describe 'RedStack::Identity::Models::Project::find' do

    it 'can retrieve a user\'s projects' do
      projects = Project.find(
                   endpoint_type: 'public',
                   token:         non_admin_default_token,
                   connection:    os.connection
                 )

      projects.must_be_instance_of Array
      projects.length.wont_be_nil
      projects.each { |p| p.must_be_instance_of Project }
    end



    it 'can retrieve all projects' do
      some_projects = Project.find(
                        endpoint_type: 'public',
                        token:         non_admin_default_token,
                        connection:    os.connection
                      )

      all_projects = Project.find(
                       endpoint_type: 'admin',
                       token:         admin_scoped_token,
                       connection:    os.connection
                     )

      all_projects.length.must_be :>, some_projects.length
    end

  end


  describe 'RedStack::Identity::Models::Project::create' do

    it 'creates a project' do
      project = Project.create(
                  attributes: new_attributes,
                  token:      admin_scoped_token,
                  connection: os.connection
                )

      project.must_be_instance_of Project
      project['name'].must_equal new_attributes[:name]
      project['description'].must_equal new_attributes[:description]
      project['enabled'].must_equal new_attributes[:enabled]

      # Cleanup
      project.delete!
    end

  end


  describe 'RedStack::Identity::Models::Project#save!' do

    it 'saves changes' do
      # the querystring param is so that the VCR gem doesn't use
      # the same mocks used in other tests.
      project = Project.create(
                  attributes:  new_attributes,
                  token:       admin_scoped_token,
                  connection:  os.connection,
                  querystring: 'before_project_update'
                )

      project[:name]        = updated_attributes[:name]
      project[:description] = updated_attributes[:description]
      project[:enabled]     = updated_attributes[:enabled]
      project.save!

      projects = Project.find(
                token:        admin_scoped_token,
                connection:   os.connection,
                querystring: 'after_project_update'
              )

      project = projects.find { |p| p[:id] == project[:id] }

      project.wont_be_nil
      project[:name].must_equal updated_attributes[:name]
      project[:description].must_equal updated_attributes[:description]
      project[:enabled].must_equal updated_attributes[:enabled]

      # Cleanup
      project.delete!
    end

  end


  describe 'RedStack::Identity::Models::Project#dirty?' do

    it 'is true when one or more attributes change' do
      project = Project.create(
                  attributes: new_attributes,
                  token:      admin_scoped_token,
                  connection: os.connection
                )

      project[:name] = updated_attributes[:name]

      project.dirty?.must_equal true

      # Cleanup
      project.delete!
    end


    it 'is false when an attribute is assigned the same value' do
      project = Project.create(
                  attributes: new_attributes,
                  token:      admin_scoped_token,
                  connection: os.connection
                )

      project[:name] = new_attributes[:name]

      project.dirty?.must_equal false

      # Cleanup
      project.delete!
    end


    it 'is false after changes have been saved' do
      project = Project.create(
                  attributes:  new_attributes,
                  token:       admin_scoped_token,
                  connection:  os.connection,
                  querystring: 'project_dirtiness_test'
                )

      project[:name]        = updated_attributes[:name]
      project[:description] = updated_attributes[:description]
      project[:enabled]     = updated_attributes[:enabled]
      project.save!

      project.dirty?.must_equal false

      # Cleanup
      project.delete!
    end

  end

  describe 'RedStack::Identity::Models::Project#delete!' do

    it 'deletes a project' do
      project = Project.create(
                  attributes: new_attributes,
                  token:      admin_scoped_token,
                  connection: os.connection
                )

      project.delete!.must_equal true

      projects = Project.find(
                token:        admin_scoped_token,
                connection:   os.connection,
                querystring: 'after_project_delete'
              )

      project = projects.find { |p| p[:id] == project[:id] }
      project.must_be_nil
    end

  end

end