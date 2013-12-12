require 'spec_helper'

describe ProjectLoader do

  describe "LoadProject" do

    context "Without properties" do
      before(:each) do
        create_list(:completed_projects, rand(1..10))
      end

      it "should return all the projects" do
        properties = nil
        projects = ProjectLoader.load_projects(properties)
        expect(projects).to match_array(Project.all)
      end
    end

    context "With properties" do
      before(:each) do
        create_list(:completed_projects, rand(1..10))
      end

      it "should return projects related to specific fields of study" do
        projects_1 = create_list(:completed_projects, rand(1..10))  
        set_different_properties(projects_1, "related_fields_of_study", "[\"Web Design\"]")

        properties = {"related_fields_of_study" => ["Web Design"]}
        projects_2 = ProjectLoader.load_projects(properties)
        expect(projects_2).to match_array(projects_1)
      end

      it "should return projects related to specific student passions" do
        projects_1 = create_list(:completed_projects, rand(1..10))
        set_different_properties(projects_1, "related_student_passions", "[\"Malaria Prevention\"]")

        properties = {"related_student_passions" => ["Malaria Prevention"]}
        projects_2 = ProjectLoader.load_projects(properties)
        expect(projects_2).to match_array(projects_1)
      end

      it "should return projects related to specific fields of study and student passions" do
        projects_1 = create_list(:completed_projects, rand(1..10))
        set_different_properties(projects_1, "related_fields_of_study", "[\"Web Design\"]")
        projects_2 = create_list(:completed_projects, rand(1..10))
        set_different_properties(projects_2, "related_student_passions", "[\"Malaria Prevention\"]")

        properties = {"related_fields_of_study" => ["Web Design"], "related_student_passions" => ["Malaria Prevention"]}
        projects_result = ProjectLoader.load_projects(properties)
        expect(projects_result).to match_array(projects_1.concat(projects_2))
      end
    end
  end

  def set_different_properties(projects, type, fields)
    projects.each do |project|
      project.properties.merge!(type => fields)
      project.save
    end
  end
end