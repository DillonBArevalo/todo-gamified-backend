class TasksController < ApplicationController
  def index

  end

  def create

  end

  def show

  end

  def edit

  end

  def destroy

  end

  private

  def task_params
    params.require(:task).permit(:title, :complete)
  end
end
