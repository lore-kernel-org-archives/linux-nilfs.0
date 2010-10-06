From: =?UTF-8?Q?=C5=81ukasz_W=C3=B3jcicki?= <lwojcicki-V+nj596LuoKHKKo6LODCOg@public.gmane.org>
Subject: Nilfs_cleanerd not clear segments ?
Date: Wed, 06 Oct 2010 12:05:53 +0200
Message-ID: <1286359553.2210.78.camel@Stanowisko-25>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Is it possible that the application will not clean nilfs_cleanerd
segments? I had this situation and the USB disk filled up to 100%. My
configuration file:

# Protection period in second.
protection_period	1800

# Minimum number of clean segments
#   0 =3D continuous cleaning
# > 0 =3D pause cleaning until less segments are available
min_clean_segments	40%

# Maximum number of clean segments
max_clean_segments	60%

=C5=81ukasz W=C3=B3jcicki


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
