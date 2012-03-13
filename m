From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Another question on nilfs_cleanerd
Date: Tue, 13 Mar 2012 23:39:52 +0900 (JST)
Message-ID: <20120313.233952.255631345.ryusuke@osrg.net>
References: <CAHmELnVsrSUSkJeJJX8p9h2+47MGWdLLiepXBYrEbJtvTEBpEQ@mail.gmail.com>
	<20120310.114047.103728078.ryusuke@osrg.net>
	<1331549638.23047.51.camel@c-s-201-122.csist.manchester.ac.uk>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1331549638.23047.51.camel-YSVCg3Hmd358UZuMZbcpAZ2qYGss1hNRlm3Br20PPvu1Qrn1Bg8BZw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Tim.Bannister-m7QheJJv02N4oUbgFh0ZNQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 12 Mar 2012 10:53:58 +0000, Tim Bannister wrote:
> On Sat, 2012-03-10, Ryusuke Konishi wrote:
> 
> > Cleanerd is safely interruptible either by unmount or a SIGINT signal.
> > 
> > If you mount the drive after that, GC restarts from the previous block
> > because the current GC algorithm selects target segments in
> > chronological order.
> > 
> > However, it will forget execution states.
> > 
> > If you were doing one pass cleaning kicked by nilfs-clean command, and
> > then unmounted and mounted again, GC doesn't resume.
> 
> I think this happened to me and I did not completely understand what had
> happened.
> In the situation described, is there any way to make the GC resume
> normally?

There is no straightforward method; the current nilfs_cleanerd does
not have the feature to save context of GC.

One pseudo method is to run the nilfs-clean command with a protection
period option:

 # nilfs-clean -p <Tpp> [<device-name>]

where <Tpp> is calculated by "<current time> - <last GC start time>"


For explanation, the relation of each event is shown in the following
figure:

  The last GC                    GC resume time
  start time  unmount     mount  (current time)
 --|-----------|-----------|------|-------------|----> time

   ----------->x aborted          ------------->
   Previous GC                     Remaining GC

   |<-----------------------------|
                 Tpp

In this case, nilfs_cleanerd processes remaining segments (blocks) and
will stop when it encounters the segment made after the last GC start
time.  Thus, we can avoid moving again the blocks already moved by the
previous GC.

Note that this pseudo method only works under the "chronological
order" GC algorithm which is currently applied.

Regards,
Ryusuke Konishi

> -- 
> Tim Bannister
> IT Services, The University of Manchester
> 
> e: Tim.Bannister-m7QheJJv02N4oUbgFh0ZNQ@public.gmane.org
> w: http://www.manchester.ac.uk/itservices
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
