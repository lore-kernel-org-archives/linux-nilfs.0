From: Rodrigo Severo <rodrigo-sUXncmUOihszlUgHzu1iJkEOCMrvLtNR@public.gmane.org>
Subject: unrecoverable nilfs?
Date: Thu, 4 May 2017 17:46:46 -0300
Message-ID: <CAOdi6iYum1qADni5sc2s-YteoTuAs7yFJ8V1MyGdq8VHyLB83w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fabricadeideias-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=OMHmekUrAkPZTnyWAcqYyM25JasO+j/7nWe4mYCcNyE=;
        b=Yo6KxNAvKCRLpbcfQTrlti4cpoISIeIOXJfDVTzzVRx7VpfVuNz/OHs1vYXG5HM88C
         fFSWeXfOh/94OHxRXNS/AuGKzJuMWWy5DlbxpJfzP0h3hxBPMj2bAMKLpbhUUVdPHFwb
         iEcFyZF4QtptRn9BKxrTpQDbyAt5J4v0cop8VGkkRBjF3LNLIUGY9gochgBB/APwOihf
         y7B5FYwOBQ4V6U3pXXz3sQEbr6V1TRA3bsif+GF2d1qISeR3VQLO7IqtVSegLaskGX3W
         Tvg3T9VQhMlxATLDvrS0BjSDJkKSpZQK95nLikup9ElHzu/tRVeqsCfabI97H8mhFsHr
         na8Q==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,


I'm a new user of nilfs2. I was having some stability issues on a file
server with some nilfs2 filesystems. AFAICT the stability issues
weren't related to nilfs2 but the nilfs2 filesystems were affected
nonetheless as the machine suffered several hard resets.

I believe the stability issues are solved but now I have one of the 5
nilfs2 filesystems changing to read-only because of the following
errors:

  48906 May  4 17:36:04 c1-df kernel: [ 1170.930585] NILFS (sdd1): bad
btree node (ino=6, blocknr=1500850679): level = 0, flags = 0x0,
nchildren = 0
  48907 May  4 17:36:04 c1-df kernel: [ 1170.931730] NILFS error
(device sdd1): nilfs_bmap_lookup_at_level: broken bmap (inode
number=6)
  48908 May  4 17:36:04 c1-df kernel: [ 1170.932804] NILFS (sdd1):
error -5 reading inode: ino=34057

How can I fix this?


Regards,

Rodrigo Severo
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
