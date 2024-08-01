Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D9D143743
	for <linux-nilfs@vger.kernel.org>; Thu,  1 Aug 2024 18:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722537621; cv=none; b=V11hvckrnf7KancCbp4fFAJmXXLPIily9haHJOq/UWSyCJAxpbtg1ZjxtzUY3rCtmOk0a81BlPIDzKHO6/eQaLZAijI1T4pumLb75vvHMHNxEm++CU7MyqM/2aLIDDFt5M0cFH5bN96RjjIviN8x+vshoA5f0On9RjnibhwZCnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722537621; c=relaxed/simple;
	bh=+EaXwA68+Bd5yGOI2AJknSt5dFtoW1fA9KBa7q0pqf0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cAEHiZRejrwy2746gBP3jO+F2NlCAG3Ycwtpiw4Y/VL+lrKeow+YmoTAYA9YnbCn8huSkDCGk99O+AWt7TWneXUzOd37PK77+0d/QnZ2FDJLKDMOffKl0w3BarNFfegnpUew+APw+i4yfvmPP94/1iF6j/uEGm4bKblMKU2ovE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b8TgMbmO; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b8TgMbmO"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2ef27bfd15bso96267481fa.2
        for <linux-nilfs@vger.kernel.org>; Thu, 01 Aug 2024 11:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722537618; x=1723142418; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m483q41jOdhXXanltEMht3kVE9+aLGcKZZVG0LN+hLM=;
        b=b8TgMbmOIVrKacLckBZiTLhbUWwD5kux0KhD0uLTV8TB5HU3MHQ0ypxGF48XBrc2+Q
         O2Xis2lZSnGkUXeT5PeJSuFS0cddC0JJNnn3kuuj+PyCsyykk34CgjJedJhtR6Ku4nRU
         WkMgs1y1uWOV0e215q0dM5zfVihg0zM0EQCiPZsO9qo+DeiVAxQBUw0oI0NfmmTj2QnB
         iirj0Epnk/Vq9UQdSXemH3F5gFi6GBFzP8z4mDs0z1k23XqT0yyGwG0BTXAyeIinnI3V
         wZCZpgnwahU9/xPHdvyUwhRJ7mriPe3jefURKDYQwIDJELMn187LbwnmILgLd1EAgis+
         Ngtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722537618; x=1723142418;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m483q41jOdhXXanltEMht3kVE9+aLGcKZZVG0LN+hLM=;
        b=N3d1S2goUgyPMsZL4iUmTD6yBmuCYjRVyyQHwrsiRgPjCHPX66d+LAzyX5bUdSD3km
         6QFVdDdqRFWcTtaOA05BltyQFxcQe7guzjNXOICsTSQb/YhlP3X49aEz/gTJh9JzNsYV
         Wgs9NeoEc8lRVU0cpesjfB7q7MFspWXVSnqKVsnKT1LZTDUgUP7FQO414GCLPBjHehAw
         KNvm3buRSMs8HUjCbkvYxCwo397Yc731WErZaa7IhEdrlulacoo8uGTLYiq6egn/7tce
         Di8bl9osRLVNbGeDnSnCz400JnOr7At5xJNazFNe7SVkpV6tXhDjqL7fowKLmuv8HXvr
         IMTw==
X-Gm-Message-State: AOJu0YyECVxVcI6MWRxdLmERNkqpfWLLcoxY37FcS7l4gPO7sGT7M0Ps
	Tl9h3wUhdhFK11a4Joq9Y89keMSAofjYFyJP0V2q2bBzwgH+sYFKm/dvuSjJscUBdLSSO5FuAhq
	RAW/jOlmyRYUFZO9tk1oSPU5nAIM=
X-Google-Smtp-Source: AGHT+IGZaQJTdhtDaiRnbAPeoZ6uepyC1eC44o09RsQsRXpmQIkzZ6gnRPHpwao4PbUxr9WKOXCXKU6oVIUoGlWsplM=
X-Received: by 2002:a2e:2e0f:0:b0:2ef:18b7:440b with SMTP id
 38308e7fff4ca-2f15aa916f0mr9235821fa.12.1722537617143; Thu, 01 Aug 2024
 11:40:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CABHrer3rrUS8x+te16eXF7HMdyYCRcoj+CS6c2T-5EmxjKO-7g@mail.gmail.com>
In-Reply-To: <CABHrer3rrUS8x+te16eXF7HMdyYCRcoj+CS6c2T-5EmxjKO-7g@mail.gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 2 Aug 2024 03:40:00 +0900
Message-ID: <CAKFNMo=gnn5TL7moJR7hgtvH_ML_3V3XXgnntPqiYq6RpzHT+A@mail.gmail.com>
Subject: Re: Potential Bug in NILFS2: Disk Space Not Freed After File Deletion
To: Yifei Liu <yifeliu@cs.stonybrook.edu>
Cc: linux-nilfs@vger.kernel.org, Erez Zadok <ezk@cs.stonybrook.edu>, 
	Geoff Kuenning <geoff@cs.hmc.edu>, Scott Smolka <sas@cs.stonybrook.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 2, 2024 at 12:44=E2=80=AFAM Yifei Liu  wrote:
>
> Dear NILFS2 Maintainers,
>
> I hope this message finds you well. I am writing to report a potential
> bug we have encountered in NILFS2 related to disk space management
> while testing it with our model checking tool, Metis. The issue arises
> after performing the following operations:
>
> Steps to Reproduce:
> 1. Mount the NILFS2 file system.
> 2. Continuously create files in the NILFS2 file system until the disk
> space is completely used up (ENOSPC).
> 3. Delete all the files created in the previous step.
> 4. Sleep for 1 minute to allow the cleanerd to run.
> 5. Repeat steps 2-4 a few times.
>
> Note: The protection_period parameter in nilfs_cleanerd.conf has been
> changed from the default 3600 seconds to 10 seconds for quicker
> observation of the bug.
>
> Expected Behavior: After deleting all files, the disk usage should
> decrease to zero or near zero, reflecting the freed space.
>
> Observed Behavior: Occasionally, after deleting the files, the file
> system remains stuck at a high usage (88% or 100% in our experiments)
> and does not free any space. When we try to create another file, it
> fails and reports "no space left on the device". We also tried
> manually running the cleanerd once the system=E2=80=99s space usage was s=
tuck
> at high percentages; even though some of the segments appear to be not
> protected and have 0% live blocks, according to the lssu output, the
> space was still not cleaned. This issue occurs sporadically and is not
> consistent across all tests (thus, we suspect it may be a race
> condition).
>
> We have created a GitHub repository containing a detailed README, the
> script used to generate this problem, an example log generated in one
> of our experiments, and the necessary files. Running this script and
> obtaining all the outputs takes approximately 10 minutes. The script
> sets up a ramdisk and mounts NILFS2 with the minimum possible size of
> 1028 KiB. Here is the link to the GitHub repository:
> https://github.com/sbu-fsl/nilfs2-full-space.git.
>
> I would appreciate any insights or assistance you could provide
> regarding this issue. If you require any further information, logs, or
> specific test cases, please let me know, and I will be happy to
> provide them.
>
> Best regards,
>
> Yifei Liu
> File systems and Storage Lab (Stony Brook University)

Hi Yifei,

I checked what your script was doing, and one thing I noticed was that
nilfs_cleanerd seemed to be started twice.

nilfs_cleanerd is designed to be automatically started via the
mount.nilfs2 helper program when you mount a device with the mount
command, and to be shut down via the umount.nilfs2 helper program
before actually issuing the unmount system call when you try to
unmount a device with the umount command.

Basically, this program is designed to be a resident program that runs
in the background while the device is mounted.

In your script, you run nilfs_cleanerd manually after mounting and
writing, so at this point, it seems that there are two nilfs_cleanerd
processes, and both of them are requesting GC on the same device.

If that happens, it will prevent fatal situations that would cause FS
destruction, but normal operation is not guaranteed regarding GC.  So,
could you please check the existing processes with the ps command?
If you start it via the mount command, it should not be started twice
for the same device.

If you want to run GC manually, use the "nilfs-clean" command to
activate nilfs_cleanerd as follows:

# nilfs-clean -p 0 $DEVICE

If you really want to run nilfs_cleanerd manually, specify "nogc"
mount option when mounting:

# mount -o nogc $DEVICE $MOUNT_POINT

In this case, you need to manually kill nilfs_cleanerd when unmounting.

Depending on your environment, you may need to specify the file system manu=
ally:

# mount -t nilfs2 -o nogc $DEVICE $MOUNT_POINT

Also, the version of nilfs-utils used is old, so in order to isolate
known bugs, it would be helpful if you could use the latest version of
nilfs-utils-2.2.11 (or nilfs-utils 2.3.0-dev) for testing.

You can download the latest version tarball from the site [1] or from
github as described in [2].

[1] https://nilfs.sourceforge.io/en/download.html
[2] https://nilfs.sourceforge.io/en/git_repos.html


Thank you.

Ryusuke Konishi
