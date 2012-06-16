From: Tim Bannister <Tim.Bannister-m7QheJJv02N4oUbgFh0ZNQ@public.gmane.org>
Subject: RE: NILFS2 under stress
Date: Sat, 16 Jun 2012 11:49:55 +0000
Message-ID: <985C1135657081458B80476678A9AF7F3ADDAC29@MBXP05.ds.man.ac.uk>
References: <CAPLqH6x7OCXS95w7-J+DLdiVkKAuKm=-8ofGwL-rcC19Z679bw@mail.gmail.com>,<20120615165024.GI16953@csmith-bm.vm.bytemark.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120615165024.GI16953-Ng8wz+J301SNY5Lh21HnMTHS2PGA244I9dF7HbQ/qKg@public.gmane.org>
Content-Language: en-GB
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

> In summary, I think NILFS is fantastic in short bursts of heavy pressure
> so long as space isn't exhausted.

OK, but if exhausting the space leads to unrecoverable / difficult-to-fix data loss then it's a poor choice of filesystem for uses where a full filesystem is unlikely but remains a possibility (eg a mail spool). If /var/tmp shouldn't be on NILFS then probably /var shouldn't be on NILFS either.

I recognise that NILFS2 is not yet described as ready for production use.

-- 
Tim Bannister
IT Services
The University of Manchester

e: Tim.Bannister-m7QheJJv02N4oUbgFh0ZNeyAPIwwu4QO@public.gmane.org
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
