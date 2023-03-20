From: Yangtao Li <frank.li-DGpbCiVdSXo@public.gmane.org>
Subject: Re: [PATCH v2, RESEND 01/10] kobject: introduce kobject_del_and_put()
Date: Mon, 20 Mar 2023 11:34:36 +0800
Message-ID: <20230320033436.71982-1-frank.li@vivo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZcSocjSGVTF5aPxsLKaFBjySrnM82IY/w/dRKgIVLtQ=;
 b=AJe7Jj4ygTrfHsWmTT4gnppAGvUAtxhf60mNZ9snE2grxP1YAVIKUBTbJ/FhJ5/07pv8NeiaL6A0EZa+g5rqelTm3a0QrRsAiby1xgmZIMDm2bFMzFic3A4Ap5WaN/3eXitQCTaKrI5A+3QSsXTbt2M68c4+uZktefL9Z3fLqeW6/lu+5gysxjGPeHLC9oRgqOFrQBpJs4tJfyf6Rq2xGn1cu82nJjuy1FyxVvwVKYWDfDDhttvFoqM+VaHI1Wg1Z76w3xT8mXwPlMgZYh/Mo3P96N+cvuT2fYhTrbVfImLo75Husxpwqnv7+ngdcX8cHu+TQp/EiAT08AePZWmV1Q==
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: clm-b10kYP2dOMg@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, dsterba-IBi9RG/b67k@public.gmane.org, xiang-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, huyue2-taVy4J1WPRFBDgjK7y7TUQ@public.gmane.org, jefflexu-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org, anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mark-qFb/fKtWg+rQT0dZR+AlfA@public.gmane.org, jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org, joseph.qi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, damien.lemoal-yzvPICuk2AC/Fx7ZUtofftBPR1lH4CV8@public.gmane.org, naohiro.aota-Sjgp3cTcYWE@public.gmane.org, jth-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-erofs-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi all,

Out of consideration for minimizing disruption, I did not send the
patchset to everyone. However, it seems that my consideration was
unnecessary, so I CC'd everyone on the first patch. If you would
like to see the entire patchset, you can access it at this address.

https://lore.kernel.org/lkml/20230319092641.41917-1-frank.li-DGpbCiVdSXo@public.gmane.org/

Thx,
Yangtao
