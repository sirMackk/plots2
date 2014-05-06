class AddSlugToDrupalNode < ActiveRecord::Migration
  def up
    # remove node_url_alias table
    add_column :node, :node_slug, :string, unique: true

    DrupalNode.skip_callback(:validation, :before, :set_slug)
    DrupalNode.all.each do |node|
      if DrupalNode.where(node_slug: node.title.parameterize).size > 0
        node.node_slug = "#{node.title}-#{Time.at(node.created).to_date.to_s}".parameterize
      else
        node.node_slug = node.title.parameterize
      end
      node.save
    end
    DrupalNode.set_callback(:validation, :before, :set_slug)
  end

  def down
    remove_column :node, :node_slug
  end
end
