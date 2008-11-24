class Details < Application
  # provides :xml, :yaml, :js

  def index
    @details = Detail.all
    display @details
  end

  def show(id)
    @detail = Detail.get(id)
    raise NotFound unless @detail
    display @detail
  end

  def new
    only_provides :html
    @detail = Detail.new
    display @detail
  end

  def edit(id)
    only_provides :html
    @detail = Detail.get(id)
    raise NotFound unless @detail
    display @detail
  end

  def create(detail)
    @detail = Detail.new(detail)
    if @detail.save
      redirect resource(@detail), :message => {:notice => "'#{@detail.name}' details saved."}
    else
      message[:error] = "API details could not be saved."
      render :new
    end
  end

  def update(id, detail)
    @detail = Detail.get(id)
    raise NotFound unless @detail
    if @detail.update_attributes(detail)
       redirect resource(@detail), :message => {:notice => "'#{@detail.name}' details updated."}
    else
      display @detail, :edit
    end
  end

  def destroy(id)
    @detail = Detail.get(id)
    raise NotFound unless @detail
    if @detail.destroy
      redirect resource(:details), :message => {:notice => "'#{@detail.name}' was deleted."}
    else
      raise InternalServerError
    end
  end

end # Details
