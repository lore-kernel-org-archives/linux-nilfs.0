From: Hendrik Levsen <hendrik-j5CO6tLloWodnm+yROfE0A@public.gmane.org>
Subject: Re: couldn't mount because of unsupported optional features
 (477e7ad1e859f753)
Date: Fri, 31 Dec 2021 09:51:23 +0000
Message-ID: <37be5d12-adea-6399-65c3-6d50008c18ff@levsen.org>
References: <39575f5e-b47a-d971-6c15-35985a35c9d5@levsen.org>
 <25037.40801.808565.662504@cyme.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=smtp-gateway.net; s=dkim2k; h=Date:Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Message-ID:From:To:References:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NZfBPdhn9i80u94sz0Gh7qjgp+uPxKd4IcmGVnPPy7I=; b=AMYqrpPU7gvAvWd8dPvoUOpIX6
        PNZqROTVyOUXurDk2ABDnaSp23zGmoo/kNhA/0e6Jb157TXJmgSFImbTVhzViAsxSkzlWlB/Ld8XA
        cXRvBHVPUKyzJn77aBYnl05+S1ebTEI5GUIdKNGTM5L3mPwlX9TWd7GYbid9I5grjImYJp0CVe+R8
        +Icu9QdbMzmG/tq7B9K0s0+4GTzJK0WWazG34h5AEhEtXhUVrV4DaGGzbKYgq6BJfsRQrqCMt3sCf
        OD8+Ih2uAOlJCrRBoFUc7vE8Z+jsIx0sbC2xp/UOMtnsxyaFgRXxcVycmFS96lIWGfh0FZKcs/O6Z
        xPD 
In-Reply-To: <25037.40801.808565.662504-5EdyzN1Ji+RYO2OccljXW7VCufUGDwFn@public.gmane.org>
Content-Language: en-GB
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 30/12/21 11:00 pm, Peter Grandi wrote:
>> Trying to mount a NILFS partition
> To be pedantic, but it matters, it is "block device" in UNIX-like
> systems, and more "NILFS2 instance", as here could be multiple
> NILFS2 instances even in a single block device (but that is a
> very rare setup usually requiring 'losetup' mounts).

Correct, being sloppy here in my terminology, it's a block device which
is a RAID-1 (+ dmcrypt/luks) which gives me confidence that the
underlying hardware is ok.

>> fails with "couldn't mount because of unsupported optional
>> features (477e7ad1e859f753)". [...]
> That does not look a lucky situation. You can use 'lscp
> /dev/...'  to list the checkpoints and try to mount an older
> checkpoint with 'mount -t nilfs2 -o cp=... /dev/... ...' to
> mount it and resume work from that. In theory older checkpoints
> will be fully consistent even if the latest one is corrupted.

Thanks Peter, it seems both lscp and mount -o cp need a functioning
super block though.

> Unless that  message means that the NILFS2 instance is corrupted
> because of "issues" (usually hardware, most common with block
> devices on USB storage devices).

I might dig into this a little deeper, the data isn't that important but
gaining a correct understanding of NILFS working principles is. My
understanding so far was that it's quite hard for data to become
entirely inaccessible.

This looks like a good idea, linear scan for segment nodes:
https://www.spinics.net/lists/linux-nilfs/msg02198.html Could be the
start of the fsck that never happened.

-- h.

