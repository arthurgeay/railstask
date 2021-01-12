# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Users
@users = User.create([
    {email: 'railstask.app@mail.fr', password: 'railstask', username: 'John Doe'},
    {email: 'michel.jambon@mail.fr', password: 'railstask', username: 'Michel Jambon'}
])

p "Created #{User.count} users"

@project = Project.create(name: 'Project n°1', description: 'Amazing project', color: '#28bce2')

ProjectUser.create([
    {user_id: User.first.id, role: 'Administrator', project_id: Project.first.id},
    {user_id: User.last.id, role: 'Membre', project_id: Project.first.id}
])

p "Create #{Project.count} projects"

@task_lists = TaskList.create([
    {name: 'Dev back', project_id: @project.id},
    {name: 'Dev front', project_id: @project.id}   
])

p "Create #{TaskList.count} task lists"

Task.create([
    {title: 'Feat 1', status: 'Not started', description: 'Example of description', duration: '1', task_list_id: TaskList.first.id},
    {title: 'Feat 2', status: 'In progress', description: 'Example of description', duration: '1', task_list_id: TaskList.last.id},
])

@task_users = TaskUser.create([
    {user_id: User.first.id, task_id: Task.first.id},
    {user_id: User.last.id, task_id: Task.first.id},
    {user_id: User.first.id, task_id: Task.last.id}
])

p "Create #{Task.count} tasks"




