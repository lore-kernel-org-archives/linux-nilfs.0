From: Christian Smith <csmith-r5H9PUQoNxUga4AWyxku7ULnMzgEhdHr@public.gmane.org>
Subject: Re: NILFS: bad btree node
Date: Sat, 26 May 2012 15:49:32 +0100
Message-ID: <20120526144932.GG18110@csmith-bm.vm.bytemark.co.uk>
References: <CAHmELnWvFNdiePs=mQJ=nqfsxJ_49zxawa9jncE-RJ2-omYHOg@mail.gmail.com> <20120525180649.GA1236@heethoofdje.13thmonkey.org> <CAHmELnVyRNGn1gda0Sw53YCSOAYMm5JUonebi-9NxaFBP7Uidw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHmELnVyRNGn1gda0Sw53YCSOAYMm5JUonebi-9NxaFBP7Uidw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kenneth Langga <klangga-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, May 26, 2012 at 02:15:41AM +0800, Kenneth Langga wrote:
> It's a 3TB harddisk. Could that be the reason?
> 
> Right now, it's mounted read-only. Is it safe to make it read/write
> again? And can I run nilfs-clean on it and maybe the error would be
> gone?
> 

You should be able to remount read/write, as you'll still have your 
old snapshots or checkpoints to mount from instead if it all goes
wrong.

In my experience, though, once the clearner fails to be able to
clean segments due to logical errors, it's game over and a
backup/mkfs/restore is needed.  But then, I mostly run NIFLS on
small slow SDD, so that's no great hardship. We desperately need
a fsck to handle scenarios like that.

I can't see the size of the disk being a problem. All the data
pointers are 64-bit, so should comfortably handle 3TB.

In short, try read-write, but be prepared to reformat.

Also, if you're using a 3TB disk for NILFS to store media
files, I'd perhaps suggest against it, if not for the reason
that backup/restore on that much data will take an age. I
currently stick to nilfs for my root filesystems, leaving
big and/or personal data on more stable, less cutting edge
filesystems.

Christian
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
