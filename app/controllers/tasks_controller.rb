class TasksController < ApplicationController
  def index
    if params[:filter] && params[:filter] != 'all'
      @tasks = Task.where({user_id: @user.id, complete: params[:filter] == 'complete'})
    else
      @tasks = @user.tasks
    end

    render json: {tasks: @tasks}
  end

  def create
    @task = @user.tasks.new(task_params)
    if @task.save
      render json: @task
    else
      render json: {errors: @task.errors.full_messages}
    end
  end

  def show
    @task = Task.find_by(id: params[:id])
    if @task && @task.user == @user
      render json: @task
    else
      render json: {errors: ["Task with id: #{params[:id]} #{ !!@task ? 'is not associated with the current user' : 'does not exist'}."]}, status: !!@task ? 403 : 404
    end
  end

  def update
    @task = Task.find_by(id: params[:id])
    if @task && @task.user == @user
      if @task.update(task_params)
        render json: @task
      else
        render json: {errors: @task.errors.full_messages}, status: 400
      end
    else
      render json: {errors: ["Task with id: #{params[:id]} #{ !!@task ? 'is not associated with the current user' : 'does not exist'}."]}, status: !!@task ? 403 : 404
    end
  end

  def destroy
    @task = Task.find_by(id: params[:id])
    if @task && @task.user == @user
      @task.destroy
    else
      render json: {errors: ["Task with id: #{params[:id]} #{ !!@task ? 'is not associated with the current user' : 'does not exist'}."]}, status: !!@task ? 403 : 404
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :complete)
  end
end
