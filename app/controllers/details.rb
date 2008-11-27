class Details < Application
  provides :xml, :yaml, :json

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
    if detail['from_url'].empty?
      @detail = Detail.new(detail)
    else
      @detail = Detail.create_from_url(detail['name'], detail['from_url'])
    end

    if @detail.save
      redirect resource(@detail), :message => {:notice => "'#{@detail.name}' saved."}
    else
      message[:error] = 'Please correct the errors below.'
      render :new
    end
  end

  def update(id, detail)
    @detail = Detail.get(id)
    raise NotFound unless @detail
    if @detail.update_attributes(detail)
      redirect resource(@detail), :message => {:notice => "'#{@detail.name}' updated."}
    else
      display @detail, :edit
    end
  end

  def update_cached(id)
    @detail = Detail.get(id)
    raise NotFound unless @detail
    if @detail.update_cached_content!
      response_message = {:notice => 'Cached content was updated.'}
    else
      response_message = {:error => 'Could not update cached content.'}
    end
    redirect resource(@detail), :message => response_message
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
