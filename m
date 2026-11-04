Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793753392;
	b=TZ40s1g2yWHzPZburNGOkS6A0WqtgpVrUHjdTcPlWGcF1GFHUqoao0Z6ZHZohkzxuT1R
	 byixEF4DByzwJD0eO/XujuHHLLJTJ1/Etpqe125j9Ge/PN+7V4xSXCrqKXh5pdME3QGTl
	 9fbXZL3XjqHISLlu9zBR6zGUjEENgJhP82BXRmOYOqTyFl/aDb5vqwp9leMvmZFQcyhXj
	 hl3iXwyiVdyNK6Sb3gnoDGXBQLPYq1TPWX+E/Xj8rq0AyLtz/cokhPkmp549uQq1JWndV
	 YBwvI5jAwPi9u+NOfttr1gIZQPom9hAihJHp26AUiaLZxDa8qFKSbQhpYMp+N4ELJIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793753392;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=/bumM81nPiENiLh9PH/Fm40C+VENRMD3A/OuAfI8Z4s=;
	b=bRRqBb58hHKyYlSc51xWkVnMCrspDCcDRHMZPL77EGWOugQC/iGN5aOngCj+9ezOI8u1
	 G4EZV9e5R3VuYXN25tL1cC7q0efT4T9ubcELkMumYKJhWhwgZ9M0UtxVr2meIzzKmr0u2
	 kBGlWL9CDTTIz58CTMlJ0QlBQa7NTh/0VlKS75K4SksRrcrvAp8MOvuJCwSYRdTLdBt8V
	 k0ygxydC5C5IX929XqyTAtJeFkPqe+eZAfGCxJN8LtIQUZreoqM/oYx1BaMxkEyX1CKm2
	 Z0VfDh5oQJ5OML7KqXNERLy+BPFdN97ONuz4IbSWkVSDuEZxKV5wKLT/LFMSYzEdNrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VT+pUP2N;
	arc=none smtp.remote-ip=209.85.210.172
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2AE606A331
	for <linux-nilfs@vger.kernel.org>; Wed,  4 Nov 2026 00:49:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B2AE606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VT+pUP2N
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-886e61fa30fso101057b3a.1
        for <linux-nilfs@vger.kernel.org>; Tue, 03 Nov 2026 16:49:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793753391; x=1794358191; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/bumM81nPiENiLh9PH/Fm40C+VENRMD3A/OuAfI8Z4s=;
        b=VT+pUP2NwuZcLnfpE6RBehWP9rj7p+v+tKoR/WVHOzz1v7CJgJGu6gqjY1V/YGEdmw
         igNrVOnPTFLv9xvYK2tnZhcPD4jqAzwLjDlQ2iFsJIT0vgZOsXkUB60qRSrv68Heg2+2
         k5XkKmMrKWtBUKDoGvgF6CjyKJx7mmzehyXgiMW8Z51NtcdDEa4LvP5GkI/GPk/JWdX0
         E0pyc83t8pyqA1wDQ4YMhv4IP3UIHbsnnJtT4+s3TyxuI9ePzpN8dD0BzwPhXNBIUBNN
         GS4KAdHBqzLrJ9upnMsWdUfiG2GuZuR+cDGx90+hJalABWpp8S3bPmquj5j2mZuikn7l
         6bxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793753391; x=1794358191;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/bumM81nPiENiLh9PH/Fm40C+VENRMD3A/OuAfI8Z4s=;
        b=ojFkYQn2NqjXm9FB1eOTuwWEGvOvGqaoczy35bxwqlgK0x4a0FJNKCGd/WH3yIgMoB
         WayaHVOm/qJ7J1GOFZJCFBdgsxzhbjlF/Iv0k/VhYrHGTTriaYz/4t7D6DmP6GY4xvd4
         LysgIA1mIGh/AWddSsPQMdg/gYgK5SqN35/D/TX0eGdnxau1iZae5LqbnNr8UoqGTyTN
         UNn1PkGxOTwm6hHHE3cJS/XHtfLQmrZ9/l0pd5uewdqyVNDTu7vLV3k0YH143QYXyVmU
         7lGtxPUV9MYuu4uU5jpysrS5ht+dzuT4uMr13Ryy1jajQraO1M28y93qw0YbfwFxQxnb
         KebA==
X-Forwarded-Encrypted: i=1; AKwUvByvmkVq7lBNxwKdeJuKVtQyvI/QXDZ7uzxpwCdNAmEHNiQR63HTeJsxbsXPZaPAfNG+YdHxihKyWyo7QA==@vger.kernel.org
X-Gm-Message-State: APuU4Z+Q/cIyo8IRwA8DN0hZO7Yzdgo2l6Fld9DvIekS7EXqZNzuYHIr
	M/1qQmg+v5R/tU9lVTmHt+3Y0IgIG/eAX5YaoZMH6z6b2FQkmmbwg3r/
X-Gm-Gg: AYBFou13ef68aRqihXEBRqOQR8++dPAKcGKqn9mEmPo47e7oi5pcSk1jIugmuQXhgNa
	srWc7woYXbNEjubGHR72jQJ8m/3vwQOn1hYCrBxSVWTnatRUVFyUOwOiYxlK97PvycE/8AXDwR/
	4xg6DI7QssWlCulmlOH8fl5Qm9hNLobvBXdgq18DsdPdic7udmEf1TAuazKKtvBuC5cnjfNzKqF
	/TzNF1oSKyc5t5yYN1D++H7459wg+wXRO9mkPV1jjHUrdHN3KfRNpAwZOhXhCqQlaQhw9uzDOMR
	YrvfDeDFmetvovs+t3UEDvZxAdmFnTR0LB+oY+dZv3Je6d8qAzqTq1kammap0XpnzDPUAJJAg+B
	X0uis4KYif6xUk4VqVOTu2AGcoxz3+aeRz48CjMITX+DNwP00Bhov5V7dfAaIEVYLuz7IgCO0Kt
	9rUDSuOjzA0OhHDoiwNJYGlaoUOawWqpx3jWGNw1gvsebtVnFrSEy87ogmNyuwqHHfSsFmmskjs
	paQ+284v6ujCXlTFwOltfLv15TSCysk3+/5yFOXX5O+USxzoliDMiEF7TavJSp5kUY2zZQ7sp87
	UKvKpsYxH4S5OZ7Cx9aRjmidAyAZi7WU5zsKl0k=
X-Received: by 2002:a05:6a20:914b:b0:3e2:9470:5303 with SMTP id adf61e73a8af0-3e928953948mr11828504637.15.1793753391239;
        Tue, 03 Nov 2026 16:49:51 -0800 (PST)
Received: from localhost ([27.122.242.71])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb46440cc7sm329325a12.3.2026.11.03.16.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 16:49:50 -0800 (PST)
Date: Wed, 4 Nov 2026 09:49:48 +0900
From: Hyunchul Lee <hyc.lee@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev,
	linux-mm@kvack.org, ntfs@lists.linux.dev,
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org,
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 17/34] ntfs: don't set SB_RDONLY after filesystem
 errors
Message-ID: <auqBLEvcurRZfGj6@hyunchul-PC02>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-17-2f44f64f0b66@kernel.org>
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-17-2f44f64f0b66@kernel.org>

On Thu, Oct 29, 2026 at 05:07:08PM +0100, Christian Brauner wrote:
> With errors=remount-ro every ntfs_error() ends up in ntfs_handle_error()
> which sets SB_RDONLY without holding s_umount. If that happens while the
> volume is frozen through bdev_freeze() thaw_super() sees a read-only
> superblock and leaves the s_writers rwsems locked so every writer hangs.
> 
> So set NV_Errors and a new NV_EmergencyRO flag instead like ext4 does.
> ntfs_emergency_state() returns EIO after a shutdown and EROFS after an
> error and the write side shutdown checks use it now. fallocate,
> ->set_acl(), FS_IOC_SETFSLABEL, FITRIM and ntfs_mft_record_free() get a
> check as well. Errors while mounting still set SB_RDONLY, nothing can
> freeze the superblock before SB_BORN.
> 
> NV_Errors already refuses a remount to read-write and since
> commit 521978c4f444 ("ntfs: sync the volume dirty bit with the recorded
> error state") the volume stays marked dirty once errors were recorded.
> But the dirty bit may not be on disk yet when the error hits and
> writeback is refused from then on. So a work item writes it right away
> because ntfs_error() can be called with mft records locked, and umount
> lets a pending one run first.
> 
> Unlinked inodes are left to chkdsk in that state. Their mft records are
> freed with direct bios while the index and bitmap updates of the
> deletion can't be written back anymore. And writing to an encrypted file
> only warns now. It called ntfs_error() which let anyone put the volume
> into the emergency state.
> 
> /proc/mounts keeps showing the volume read-write. Writes through file
> descriptors opened before the error fail with EROFS.
> 
> Fixes: 6251f0b0de7d ("ntfs: update super block operations")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good to me.

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

-- 
Thanks,
Hyunchul
