From: Yangtao Li <frank.li-DGpbCiVdSXo@public.gmane.org>
Subject: Re: [PATCH v2, RESEND 01/10] kobject: introduce kobject_del_and_put()
Date: Mon, 20 Mar 2023 15:11:40 +0800
Message-ID: <20230320071140.44748-1-frank.li@vivo.com>
References: <e4b8012d-32df-e054-4a2a-772fda228a6a@opensource.wdc.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KzjxnsJbJDnjGik/CxYLa2sqgyThkXSxTjJWJGKdsro=;
 b=NVgS6ISxsXSX+v87J+SfF9KPotarq2icOckIsyABALk7Wy8+QewHEoZtAAoqvpHH3+s68XkUl7LOHbtNueev0cHNtfneMNVJJB4BA90Iib1r716fwuK4Nb8IQMH85ALYcDyzkv0pVMKK59CA4W+r6zobl0YEg+57SzYCduvfsCiYcVRzN8uXNRhcxy8twqxdusEqi/PYLI8Ps8XQyBooOZHH0r61sFkmNAF+pRGVCofq0Q94fFc3YdCsRVscl+aZmlIdj+n5Ixpy+ofPJ8711kU5Iadhl1vNF2yUjZZt9ye33hfqMCl0YwBNAZ3g8EGDrCNtANPABpuSYvV/sfv4Dw==
In-Reply-To: <e4b8012d-32df-e054-4a2a-772fda228a6a-yzvPICuk2AC/Fx7ZUtofftBPR1lH4CV8@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: clm-b10kYP2dOMg@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, dsterba-IBi9RG/b67k@public.gmane.org, xiang-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, huyue2-taVy4J1WPRFBDgjK7y7TUQ@public.gmane.org, jefflexu-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org, anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mark-qFb/fKtWg+rQT0dZR+AlfA@public.gmane.org, jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org, joseph.qi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, damien.lemoal-yzvPICuk2AC/Fx7ZUtofftBPR1lH4CV8@public.gmane.org, naohiro.aota-Sjgp3cTcYWE@public.gmane.org, jth-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-erofs-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi filesystem maintainers,

> Hard to comment on patches with this. It is only 10 patches. So send everything please.

If you are interested in the entire patchset besides Damien,
please let me know. I'll resend the email later to cc more people.

Thx,
Yangtao
