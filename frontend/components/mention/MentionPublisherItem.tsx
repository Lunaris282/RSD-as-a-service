type MentionPublisherItemProps = {
  publisher: string | null
  page: string | null
  publication_year: number | null
  className?:string
}
export default function MentionPublisherItem(
  {publisher, page, publication_year, className}: MentionPublisherItemProps
) {

  if (publisher && page && publication_year) {
    return (
      <div className={className}>
        Published by {publisher} in {publication_year}, page: {page}
      </div>
    )
  }
  if (publisher && publication_year) {
    return (
      <div className={className}>
        Published by {publisher} in {publication_year}
      </div>
    )
  }
  if (publisher) {
    return (
      <div className={className}>
        Published by {publisher}
      </div>
    )
  }
  return null
}