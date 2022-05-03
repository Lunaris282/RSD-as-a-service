import ListItem from '@mui/material/ListItem'
import ListItemText from '@mui/material/ListItemText'
import ListItemAvatar from '@mui/material/ListItemAvatar'
import DeleteIcon from '@mui/icons-material/Delete'
import EditIcon from '@mui/icons-material/Edit'
import IconButton from '@mui/material/IconButton'

import {MaintainerOfProject} from './useProjectMaintainer'
import ContributorAvatar from '~/components/software/ContributorAvatar'
import {getDisplayInitials, splitName} from '~/utils/getDisplayName'

type ProjectMaintainerProps = {
  pos:number
  maintainer: MaintainerOfProject
  onEdit: (pos: number) => void
  onDelete: (pos:number) => void
}


export default function ProjectMaintainer({pos, maintainer, onEdit, onDelete}: ProjectMaintainerProps) {
  const {name, email, affiliation, avatar_url} = maintainer
  const displayInitials = getDisplayInitials(splitName(name))
  return (
    <ListItem
      key={email}
      secondaryAction={
        <>
          <IconButton
            edge="end"
            aria-label="edit"
            sx={{marginRight: '1rem'}}
            onClick={() => {
              onEdit(pos)
            }}
          >
            <EditIcon />
          </IconButton>
          <IconButton
            edge="end"
            aria-label="delete"
            onClick={() => {
              onDelete(pos)
            }}
          >
            <DeleteIcon />
          </IconButton>
        </>
      }
      sx={{
        // this makes space for buttons
        paddingRight:'6.5rem',
        '&:hover': {
          backgroundColor:'grey.100'
        }
      }}
      >
        <ListItemAvatar>
          <ContributorAvatar
            avatarUrl={avatar_url ?? ''}
            displayName={name ?? ''}
            displayInitials={displayInitials}
          />
        </ListItemAvatar>
        <ListItemText primary={name} secondary={affiliation} />
    </ListItem>
  )
}
