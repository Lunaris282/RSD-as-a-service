// SPDX-FileCopyrightText: 2022 Dusan Mijatovic (dv4all)
// SPDX-FileCopyrightText: 2022 dv4all
//
// SPDX-License-Identifier: Apache-2.0

/* eslint-disable @next/next/no-img-element */
import PhotoSizeSelectActualOutlinedIcon from '@mui/icons-material/PhotoSizeSelectActualOutlined'

type ImageAsBackgroundProps = {
  src: string | null | undefined
  alt: string,
  className: string,
  bgSize?: string,
  bgPosition?: string
  noImgMsg?: string
}

export default function ImageAsBackground(
  {src, alt, className, bgSize = 'cover', bgPosition = 'top center',
  noImgMsg = 'no image avaliable'}: ImageAsBackgroundProps
) {

  if (!src) {
    return (
      <div
        className={`${className} flex flex-col justify-center items-center text-grey-500 rounded-sm`}
      >
        <PhotoSizeSelectActualOutlinedIcon
          sx={{
            width: '4rem',
            height: '4rem'
          }}
        />
        <div className="uppercase text-center">{noImgMsg}</div>
      </div>
    )
  }
  return (
    <div
      role="img"
      style={{
        flex: 1,
        backgroundImage: `url('${src}')`,
        backgroundSize: bgSize,
        backgroundPosition: bgPosition,
        backgroundRepeat: 'no-repeat',
      }}
      aria-label={alt}
      className={`${className} rounded-sm`}
    ></div>
  )
}
