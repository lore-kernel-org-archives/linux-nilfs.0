From: Tim Bannister <Tim.Bannister-m7QheJJv02N4oUbgFh0ZNQ@public.gmane.org>
Subject: Re: Another question on nilfs_cleanerd
Date: Mon, 12 Mar 2012 10:53:58 +0000
Message-ID: <1331549638.23047.51.camel@c-s-201-122.csist.manchester.ac.uk>
References: <CAHmELnVsrSUSkJeJJX8p9h2+47MGWdLLiepXBYrEbJtvTEBpEQ@mail.gmail.com>
	 <20120310.114047.103728078.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120310.114047.103728078.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, 2012-03-10, Ryusuke Konishi wrote:

> Cleanerd is safely interruptible either by unmount or a SIGINT signal.
> 
> If you mount the drive after that, GC restarts from the previous block
> because the current GC algorithm selects target segments in
> chronological order.
> 
> However, it will forget execution states.
> 
> If you were doing one pass cleaning kicked by nilfs-clean command, and
> then unmounted and mounted again, GC doesn't resume.

I think this happened to me and I did not completely understand what had
happened.
In the situation described, is there any way to make the GC resume
normally?

-- 
Tim Bannister
IT Services, The University of Manchester

e: Tim.Bannister-m7QheJJv02N4oUbgFh0ZNQ@public.gmane.org
w: http://www.manchester.ac.uk/itservices

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
