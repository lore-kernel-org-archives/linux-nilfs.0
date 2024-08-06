Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3705211C83
	for <linux-nilfs@vger.kernel.org>; Tue,  6 Aug 2024 02:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722912177; cv=none; b=un+Fg7KQdNa76a1XjlR1WD1M6f/wlssnB04UE4solS05qeQ4UUMd6kep29FRguqS33PX6c6NMDKR1r54K78xTxDRIR5o2h2J9V9yoNW/DB1dSDxpAvgw5QPwxLqIhTxBRjHQkKK+irbbY7fRkEtfphx8AH/JF1+2IqZf6qf91oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722912177; c=relaxed/simple;
	bh=IZe7PShcxK62+MPgiP782pPQc+DAeONwbXgSY3bNk5Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a3SgSIkOK1aKYzGRXKQ/VIZonelKMJsEskTbUUyAbGmpf6Q70iMXOZdw+4Lo8mcKGVU/9BpFVxl4C+3WIfnhQanxFh7hq9MF72vdi81TPqD75g/Y9cZvfPzn8vXJD2Fkl35uhhSZekM6s9z0znE6fwr+GsTRH9xTSkd8eGUcE+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lYJntPOk; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lYJntPOk"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-530c2e5f4feso168078e87.0
        for <linux-nilfs@vger.kernel.org>; Mon, 05 Aug 2024 19:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722912173; x=1723516973; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=88vdng17SJc3zOCu1DUkca7n2JgWs5wAJwR9uUb9Dqc=;
        b=lYJntPOkS6HvSugmHtP4z/SsCKoKbcm0MmY5pR142tnwW9lB5t9Ii3eyN/JGcsUgsR
         Hcs8P2ldI5VNOF3nwyjRlaYYhwNUd3X9MKVXcnvAm+RDgPBCeShefGWIUOlMWDn1lXyi
         xt903vmgD6z2qCblAA9BlOMg+BCJ4bufY4V4LdQj2koha+q0/zxzSbumGyrTlg3EJkDA
         0tzbM96Sp4uFaC8bHzaiBaaBIYdbnIDFTQzn9CcybbWTB8dqisUiwKa+bROUrc8YORMK
         yvOpyGT32LKzKpwJko75814iZ62lU6c2UHO44IABfggeXJ1gRWblMktvxIw+o2H2J+GO
         QscQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722912173; x=1723516973;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=88vdng17SJc3zOCu1DUkca7n2JgWs5wAJwR9uUb9Dqc=;
        b=Mtmd/SAFknu3PncgR9OuAeD1GXdVIvXm3Vc8kATVIKqrAl6g6HRLAUFfrylBL6U96/
         65lnnFta8eCX+aTQmJhPHAFi+98mV+3iqg1gMVTdF4dpcUviSetyoLp5DVjCaOdV7OyK
         vLoyzu0aZfRWmfEuVaT0nQl75N8JfQefqjgLHjDWhCDnX77MkrLS667493WGmRCvbiEg
         AoFUYJ5xl1tsplzdDZX6J4RGU0A5UXBCc3ef3UIiD5nB4IJdrsEOlwAhpeKEDoif2Axg
         ynCGiyYlOW/TEgJ8hre8LcSock5mRo8UZjNLhqyFsRqeSdV//GIFs6UuYY/pz4m0EcTl
         0e3g==
X-Gm-Message-State: AOJu0YysyXUJfG6bkIkZOuECP31VtpGdFRO+MXDb6B4qfZqJD3hFNItx
	wzpMZWWWTHB3sRaEP8yNM2v6y2BvSX9iM257/4VxUNAJdTyT0cKIHFp33sJOaW/pQUpkEwFrHKC
	6uFcBP9xr0gwh047ADpoqg0yz3VQ=
X-Google-Smtp-Source: AGHT+IG0QeqevwvtMiCPdmSVt1DJP3FVTpnqn859ZJvZzXirNVM6KJJ23VCOIFrPmPyy1R9bFRAGZN+w1wXa6Am1a7M=
X-Received: by 2002:a05:6512:3088:b0:52e:9fd3:f0ca with SMTP id
 2adb3069b0e04-530bb38530amr9069152e87.33.1722912172902; Mon, 05 Aug 2024
 19:42:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CABHrer3rrUS8x+te16eXF7HMdyYCRcoj+CS6c2T-5EmxjKO-7g@mail.gmail.com>
 <CAKFNMo=gnn5TL7moJR7hgtvH_ML_3V3XXgnntPqiYq6RpzHT+A@mail.gmail.com> <CABHrer2U3nNFQzT0QLjTHJ9yUiwOuxtcP44jEP4huTSRTED2tg@mail.gmail.com>
In-Reply-To: <CABHrer2U3nNFQzT0QLjTHJ9yUiwOuxtcP44jEP4huTSRTED2tg@mail.gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Tue, 6 Aug 2024 11:42:36 +0900
Message-ID: <CAKFNMokChMGs5FaXRhCDsh6Nd0XtEdoF_LBs_6HYXY8HV=khrg@mail.gmail.com>
Subject: Re: Potential Bug in NILFS2: Disk Space Not Freed After File Deletion
To: Yifei Liu <yifeliu@cs.stonybrook.edu>
Cc: linux-nilfs@vger.kernel.org, Erez Zadok <ezk@cs.stonybrook.edu>, 
	Geoff Kuenning <geoff@cs.hmc.edu>, Scott Smolka <sas@cs.stonybrook.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 5, 2024 at 1:31=E2=80=AFPM Yifei Liu wrote:
>
> Hi Ryusuke,
>
> Thank you for your prompt reply!
>
> I investigated this issue further based on your feedback.  Yes, we
> manually started nilfs_cleanerd in addition to the one triggered by
> the mount.nilfs2, so two nilfs_cleanerd processes are running as
> indicated in the "ps" output.
>
> I used the latest version of nilfs-utils-2.2.11 and conducted some new
> experiments.  However, when I relied solely on the "nilfs_cleanerd"
> started by "mount.nilfs2", the NILFS2 file system remained at a high
> usage percentage (88%) even after all files and directories were
> deleted.

Well, what you're saying is that the file system got stuck.  And you
cannot recover it even by running the "nilfs-clean" command or
manually starting nilfs_cleanerd.  Right?

It certainly seems that reserved segments can be used up and the file
system can get stuck, especially in environments with small segment
sizes and a small number of segments.

Since NILFS is a log-structured filesystem, it requires writing logs
to change the state of the filesystem, including GC, so we may need to
improve disk full management.

I was able to resolve the stuck state by expanding the partition and
then using nilfs-resize to expand the filesystem.

It may not be possible to fundamentally solve the problem (other than
mitigating it), but I've recognized the problem.
Thank you for your feedback.

> I also tried mounting with the "nogc" option and manually
> starting the cleaner using "nilfs_cleanerd -p 1 ${DEVICE}
> ${MOUNT_POINT}", which consistently reduced space usage to 50%.  I
> believe this is because the manually-started nilfs_cleanerd sets the
> interval (-p) to 1.  I would like to know if the space usage result
> after cleaning is reasonable, considering it was initially 25% when
> the file system was first mounted.

At present, I think the most accurate way to check whether disk usage
is reasonable is to use "lssu -l", which uses the same function as GC
to determine whether blocks are alive or dead.  Note that this command
allows you to specify a protection period as an option.

If you want to dig deeper into what is going on, one way is to output
the block configuration of the segment you want to see with the
"dumpseg" command (just for your reference).

> Additionally, it seems like
> running two instances of nilfs_cleanerd for a single device can
> potentially cause issues that prevent the cleaner from freeing up
> space.

Multiple invocation of nilfs_cleanerd on the same device are not
supported, so frankly I would like to exclude them.  However, to avoid
accidental problems, I would like to deal with that case as well if
possible.

Thanks,
Ryusuke Konishi

>
> I have updated the script accordingly.  Please feel free to contact me
> if you need anything from my side.  Thanks again.
>
> Best regards,
>
> Yifei Liu
> File systems and Storage Lab (Stony Brook University)

>
>
> On Thu, Aug 1, 2024 at 2:40=E2=80=AFPM Ryusuke Konishi
> <konishi.ryusuke@gmail.com> wrote:
> >
> > On Fri, Aug 2, 2024 at 12:44=E2=80=AFAM Yifei Liu  wrote:
> > >
> > > Dear NILFS2 Maintainers,
> > >
> > > I hope this message finds you well. I am writing to report a potentia=
l
> > > bug we have encountered in NILFS2 related to disk space management
> > > while testing it with our model checking tool, Metis. The issue arise=
s
> > > after performing the following operations:
> > >
> > > Steps to Reproduce:
> > > 1. Mount the NILFS2 file system.
> > > 2. Continuously create files in the NILFS2 file system until the disk
> > > space is completely used up (ENOSPC).
> > > 3. Delete all the files created in the previous step.
> > > 4. Sleep for 1 minute to allow the cleanerd to run.
> > > 5. Repeat steps 2-4 a few times.
> > >
> > > Note: The protection_period parameter in nilfs_cleanerd.conf has been
> > > changed from the default 3600 seconds to 10 seconds for quicker
> > > observation of the bug.
> > >
> > > Expected Behavior: After deleting all files, the disk usage should
> > > decrease to zero or near zero, reflecting the freed space.
> > >
> > > Observed Behavior: Occasionally, after deleting the files, the file
> > > system remains stuck at a high usage (88% or 100% in our experiments)
> > > and does not free any space. When we try to create another file, it
> > > fails and reports "no space left on the device". We also tried
> > > manually running the cleanerd once the system=E2=80=99s space usage w=
as stuck
> > > at high percentages; even though some of the segments appear to be no=
t
> > > protected and have 0% live blocks, according to the lssu output, the
> > > space was still not cleaned. This issue occurs sporadically and is no=
t
> > > consistent across all tests (thus, we suspect it may be a race
> > > condition).
> > >
> > > We have created a GitHub repository containing a detailed README, the
> > > script used to generate this problem, an example log generated in one
> > > of our experiments, and the necessary files. Running this script and
> > > obtaining all the outputs takes approximately 10 minutes. The script
> > > sets up a ramdisk and mounts NILFS2 with the minimum possible size of
> > > 1028 KiB. Here is the link to the GitHub repository:
> > > https://github.com/sbu-fsl/nilfs2-full-space.git.
> > >
> > > I would appreciate any insights or assistance you could provide
> > > regarding this issue. If you require any further information, logs, o=
r
> > > specific test cases, please let me know, and I will be happy to
> > > provide them.
> > >
> > > Best regards,
> > >
> > > Yifei Liu
> > > File systems and Storage Lab (Stony Brook University)
> >
> > Hi Yifei,
> >
> > I checked what your script was doing, and one thing I noticed was that
> > nilfs_cleanerd seemed to be started twice.
> >
> > nilfs_cleanerd is designed to be automatically started via the
> > mount.nilfs2 helper program when you mount a device with the mount
> > command, and to be shut down via the umount.nilfs2 helper program
> > before actually issuing the unmount system call when you try to
> > unmount a device with the umount command.
> >
> > Basically, this program is designed to be a resident program that runs
> > in the background while the device is mounted.
> >
> > In your script, you run nilfs_cleanerd manually after mounting and
> > writing, so at this point, it seems that there are two nilfs_cleanerd
> > processes, and both of them are requesting GC on the same device.
> >
> > If that happens, it will prevent fatal situations that would cause FS
> > destruction, but normal operation is not guaranteed regarding GC.  So,
> > could you please check the existing processes with the ps command?
> > If you start it via the mount command, it should not be started twice
> > for the same device.
> >
> > If you want to run GC manually, use the "nilfs-clean" command to
> > activate nilfs_cleanerd as follows:
> >
> > # nilfs-clean -p 0 $DEVICE
> >
> > If you really want to run nilfs_cleanerd manually, specify "nogc"
> > mount option when mounting:
> >
> > # mount -o nogc $DEVICE $MOUNT_POINT
> >
> > In this case, you need to manually kill nilfs_cleanerd when unmounting.
> >
> > Depending on your environment, you may need to specify the file system =
manually:
> >
> > # mount -t nilfs2 -o nogc $DEVICE $MOUNT_POINT
> >
> > Also, the version of nilfs-utils used is old, so in order to isolate
> > known bugs, it would be helpful if you could use the latest version of
> > nilfs-utils-2.2.11 (or nilfs-utils 2.3.0-dev) for testing.
> >
> > You can download the latest version tarball from the site [1] or from
> > github as described in [2].
> >
> > [1] https://nilfs.sourceforge.io/en/download.html
> > [2] https://nilfs.sourceforge.io/en/git_repos.html
> >
> >
> > Thank you.
> >
> > Ryusuke Konishi
