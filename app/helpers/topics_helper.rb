module TopicsHelper
  class TopicSearch
    include SearchObject.module(:model)

    scope { Topic.all }

    option(:term) {
      |scope, value| scope.where("topics.subject LIKE ? OR topics.body LIKE ?",
                                 "%#{value}%", "%#{value}%")
    }
  end
end
