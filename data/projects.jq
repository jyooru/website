map(select(.archived or .fork | not)) |

map({ name, value: . }) |
from_entries |

map_values({
  description,
  extra: {
    using: .language,
    stars: .stargazers_count
  }
}) 
