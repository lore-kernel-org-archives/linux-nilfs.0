Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B0A33CA
	for <linux-nilfs@vger.kernel.org>; Mon,  5 Aug 2024 04:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722832263; cv=none; b=fYBTz+U+vQ9Q8TiP+OE5kysX5L/BiMh99HiuKKdTcTvmJxOiIRkg+zIuoMYJQ6LKuk6XKadQaUDHQDS+ymdAdcCQTTkUFdBFcXfiliA0Zk8uR3+wJI6ZkYFx8SaZ5j60Utq7IW/GELscdGTpPAUgGd5FsiQvhAssZKwg2JfFeCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722832263; c=relaxed/simple;
	bh=0W+zsRAZuwByc9PXTSMshmARJHR/6EI2/fhHbnhllkg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q4TVm11MT1ewf0NKtYMUhD+HitXaHR1hRY1tElDI0rhZcr4ulh4mtj5G8eX762zl3heoYR0Y8F2j2qUTA4Zil4LTGzOKcwOAvD/KtKfHSYngIgD/opl7B3010VWcQVVKy/Ft69vLbaAfamV6E+A/ZXZJOHWyTV9QFUZDyMdvxP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cs.stonybrook.edu; spf=pass smtp.mailfrom=cs.stonybrook.edu; dkim=pass (1024-bit key) header.d=stonybrook.edu header.i=@stonybrook.edu header.b=Y9g5bNnE; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cs.stonybrook.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.stonybrook.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=stonybrook.edu header.i=@stonybrook.edu header.b="Y9g5bNnE"
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e0857a11862so8669530276.1
        for <linux-nilfs@vger.kernel.org>; Sun, 04 Aug 2024 21:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=stonybrook.edu; s=sbu-gmail; t=1722832259; x=1723437059; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bYEoVmNrf/dMRVwdgzP/hRcnjlq9qgP84/BuxlsQGnE=;
        b=Y9g5bNnExWJY+2JongfEznZdG5R3XhDvHf0Cy7zoOOXjwGwgaf/QMykM94Ni+1Botb
         1iIeI6QoXUIxsBW/J/UqW3xdcXNM0wQv/KMPojMDfqpdsUo6JJg7GGpHWNpNDDl3kwwm
         UE0YglFvXgSQoDWRBOgLm5VSa8g4aJB7j1dxM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722832259; x=1723437059;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bYEoVmNrf/dMRVwdgzP/hRcnjlq9qgP84/BuxlsQGnE=;
        b=IIBIuOTBdIEZsGbW1WwM4wN3tQES9unHb2kRfpLajxj17zM3xoMuh9szmIrTQkC+XN
         Sz+heBp7D7WdxkgQTrfYomGWmtomg7cvhm2Q8f1WjWIFCQzTIRW3a3wl/jayWy0xn2a5
         09zVHTRPIemi/LSvyoJh+rClwXLZR/ABY4AgGEbDgOyclCu3gNsTKM9Du1ZW3ZxCXGN9
         0A5ZevvKqQbipfhVykRpKFJsdqqSnejrlIEbv3amlxm6ZURazHmiEhHeFCRaroKzhnUn
         6RI01VXuLmWY3GDtofNQEmyb5aDPt98Jv/2OWhCquEeFCPChS3hyDN5rym2VwcHryvD+
         Eclw==
X-Gm-Message-State: AOJu0Ywat5DctbVy6KqP9cXMicpsl08kowW8hKZpiakJwV/FRN0qYK/Y
	08X4GPDvDmzEhV/xm2cETqTwZI1QuEX+p8wE0ooxx6DT1dELEye+SOhjkaNb93zk3d/ugDcvCY9
	PjdpVHTMrzgOOEfVKlND0mA6bhdIlZoAG/rMVVQ==
X-Google-Smtp-Source: AGHT+IHfPl8R0B0y0kU0pIQ2OcE3sxr/U9fEwit+ZhnP7nWmQ/4vnxpPi7GruZzxe1TDBOtV5FRm2MtK8mo4FtFEPUs=
X-Received: by 2002:a05:6902:f89:b0:e0b:c99d:b6d1 with SMTP id
 3f1490d57ef6-e0bde3dc71fmr9450274276.25.1722832259329; Sun, 04 Aug 2024
 21:30:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CABHrer3rrUS8x+te16eXF7HMdyYCRcoj+CS6c2T-5EmxjKO-7g@mail.gmail.com>
 <CAKFNMo=gnn5TL7moJR7hgtvH_ML_3V3XXgnntPqiYq6RpzHT+A@mail.gmail.com>
In-Reply-To: <CAKFNMo=gnn5TL7moJR7hgtvH_ML_3V3XXgnntPqiYq6RpzHT+A@mail.gmail.com>
From: Yifei Liu <yifeliu@cs.stonybrook.edu>
Date: Mon, 5 Aug 2024 00:30:48 -0400
Message-ID: <CABHrer2U3nNFQzT0QLjTHJ9yUiwOuxtcP44jEP4huTSRTED2tg@mail.gmail.com>
Subject: Re: Potential Bug in NILFS2: Disk Space Not Freed After File Deletion
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: linux-nilfs@vger.kernel.org, Erez Zadok <ezk@cs.stonybrook.edu>, 
	Geoff Kuenning <geoff@cs.hmc.edu>, Scott Smolka <sas@cs.stonybrook.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ryusuke,

Thank you for your prompt reply!

I investigated this issue further based on your feedback.  Yes, we
manually started nilfs_cleanerd in addition to the one triggered by
the mount.nilfs2, so two nilfs_cleanerd processes are running as
indicated in the "ps" output.

I used the latest version of nilfs-utils-2.2.11 and conducted some new
experiments.  However, when I relied solely on the "nilfs_cleanerd"
started by "mount.nilfs2", the NILFS2 file system remained at a high
usage percentage (88%) even after all files and directories were
deleted.  I also tried mounting with the "nogc" option and manually
starting the cleaner using "nilfs_cleanerd -p 1 ${DEVICE}
${MOUNT_POINT}", which consistently reduced space usage to 50%.  I
believe this is because the manually-started nilfs_cleanerd sets the
interval (-p) to 1.  I would like to know if the space usage result
after cleaning is reasonable, considering it was initially 25% when
the file system was first mounted.  Additionally, it seems like
running two instances of nilfs_cleanerd for a single device can
potentially cause issues that prevent the cleaner from freeing up
space.

I have updated the script accordingly.  Please feel free to contact me
if you need anything from my side.  Thanks again.

Best regards,

Yifei Liu
File systems and Storage Lab (Stony Brook University)



On Thu, Aug 1, 2024 at 2:40=E2=80=AFPM Ryusuke Konishi
<konishi.ryusuke@gmail.com> wrote:
>
> On Fri, Aug 2, 2024 at 12:44=E2=80=AFAM Yifei Liu  wrote:
> >
> > Dear NILFS2 Maintainers,
> >
> > I hope this message finds you well. I am writing to report a potential
> > bug we have encountered in NILFS2 related to disk space management
> > while testing it with our model checking tool, Metis. The issue arises
> > after performing the following operations:
> >
> > Steps to Reproduce:
> > 1. Mount the NILFS2 file system.
> > 2. Continuously create files in the NILFS2 file system until the disk
> > space is completely used up (ENOSPC).
> > 3. Delete all the files created in the previous step.
> > 4. Sleep for 1 minute to allow the cleanerd to run.
> > 5. Repeat steps 2-4 a few times.
> >
> > Note: The protection_period parameter in nilfs_cleanerd.conf has been
> > changed from the default 3600 seconds to 10 seconds for quicker
> > observation of the bug.
> >
> > Expected Behavior: After deleting all files, the disk usage should
> > decrease to zero or near zero, reflecting the freed space.
> >
> > Observed Behavior: Occasionally, after deleting the files, the file
> > system remains stuck at a high usage (88% or 100% in our experiments)
> > and does not free any space. When we try to create another file, it
> > fails and reports "no space left on the device". We also tried
> > manually running the cleanerd once the system=E2=80=99s space usage was=
 stuck
> > at high percentages; even though some of the segments appear to be not
> > protected and have 0% live blocks, according to the lssu output, the
> > space was still not cleaned. This issue occurs sporadically and is not
> > consistent across all tests (thus, we suspect it may be a race
> > condition).
> >
> > We have created a GitHub repository containing a detailed README, the
> > script used to generate this problem, an example log generated in one
> > of our experiments, and the necessary files. Running this script and
> > obtaining all the outputs takes approximately 10 minutes. The script
> > sets up a ramdisk and mounts NILFS2 with the minimum possible size of
> > 1028 KiB. Here is the link to the GitHub repository:
> > https://github.com/sbu-fsl/nilfs2-full-space.git.
> >
> > I would appreciate any insights or assistance you could provide
> > regarding this issue. If you require any further information, logs, or
> > specific test cases, please let me know, and I will be happy to
> > provide them.
> >
> > Best regards,
> >
> > Yifei Liu
> > File systems and Storage Lab (Stony Brook University)
>
> Hi Yifei,
>
> I checked what your script was doing, and one thing I noticed was that
> nilfs_cleanerd seemed to be started twice.
>
> nilfs_cleanerd is designed to be automatically started via the
> mount.nilfs2 helper program when you mount a device with the mount
> command, and to be shut down via the umount.nilfs2 helper program
> before actually issuing the unmount system call when you try to
> unmount a device with the umount command.
>
> Basically, this program is designed to be a resident program that runs
> in the background while the device is mounted.
>
> In your script, you run nilfs_cleanerd manually after mounting and
> writing, so at this point, it seems that there are two nilfs_cleanerd
> processes, and both of them are requesting GC on the same device.
>
> If that happens, it will prevent fatal situations that would cause FS
> destruction, but normal operation is not guaranteed regarding GC.  So,
> could you please check the existing processes with the ps command?
> If you start it via the mount command, it should not be started twice
> for the same device.
>
> If you want to run GC manually, use the "nilfs-clean" command to
> activate nilfs_cleanerd as follows:
>
> # nilfs-clean -p 0 $DEVICE
>
> If you really want to run nilfs_cleanerd manually, specify "nogc"
> mount option when mounting:
>
> # mount -o nogc $DEVICE $MOUNT_POINT
>
> In this case, you need to manually kill nilfs_cleanerd when unmounting.
>
> Depending on your environment, you may need to specify the file system ma=
nually:
>
> # mount -t nilfs2 -o nogc $DEVICE $MOUNT_POINT
>
> Also, the version of nilfs-utils used is old, so in order to isolate
> known bugs, it would be helpful if you could use the latest version of
> nilfs-utils-2.2.11 (or nilfs-utils 2.3.0-dev) for testing.
>
> You can download the latest version tarball from the site [1] or from
> github as described in [2].
>
> [1] https://nilfs.sourceforge.io/en/download.html
> [2] https://nilfs.sourceforge.io/en/git_repos.html
>
>
> Thank you.
>
> Ryusuke Konishi
