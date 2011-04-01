class Admin::NewsController < ApplicationController
  
  before_filter :require_admin!
  uses_tiny_mce :only => [:index, :new, :edit]
  
  def index
    
  end
  
  def show
    
  end
  
  def new
    
  end
  
  def create
    
  end
  
  def edit
    
  end
  
  def update
    
  end
  
  def destroy
    
  end
  
end
