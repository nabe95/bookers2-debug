class SearchesController < ApplicationController
    def search 
        @model = params[:model] #検索モデルの選択
        @content = params[:content] #検索ワード
        @method = params[:method] #検索方法
        if @model == 'user'
            @records = User.search_for(@content, @method)
        else
            @records = Book.search_for(@content, @method)
        end
    end
end
