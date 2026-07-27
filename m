Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF203F58D7;
	Mon, 27 Jul 2026 09:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785145415; cv=none; b=rMAcQfNVzNQ31RiGKG/slXZekoE6U1AJUnDM0j1YaoQYRjDLekfsabJNGWz047S7rv2Eq4UntcJhRQXE65noNi8q2eD7ehys6LduJ5CUHr/Onky2lQKbHRolzqK6KxR5QEbzAt9vKi28Z+4UmXvmA2xfLJ2AafumB8G8JvwlxpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785145415; c=relaxed/simple;
	bh=tBwWYEMHx+hW/22ynowJbTQdQawfP/hz+J0IlS8uazI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=lEW2uWZpD2Q2sw1xWO+1F6Q/UFMJzO8/rNoG0yw7bvei3gvtulGrYUt8X2UPyvaZ9EY2yqQOAjAU7Y30K7ElHSKoGVP92SMNJFpTjyF51fWMnY7ELBw3q0e1WXF96NZDS5cgv+xuO4QR6YAiGUOR99IryjFViLjuZOZCL1CsJNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QGJurs1k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QGJurs1k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A00C1F00A3A;
	Mon, 27 Jul 2026 09:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785145413;
	bh=Wi0zyBRULHFydFV8l+ZqZIRgETHls70sQ+5J5+MHC9A=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=QGJurs1k0PeYCSuM6ATt40wk+3hjDvnNRbpzy69iN7kPgywSgitswdwTpxEvTMZ5u
	 UraQDvBkuQyO86sHguRNl6CsfnK/vxA/AvzgB5wKK/lc/GckrOQtJHQPVLQs9EEYJ/
	 1Cs5TzLJZKnxKt+tpP68mcDzcagurcZoqQOvJH9DMLmT+eTBZ8/pR6yF+QYHVw5uup
	 UEFVmXIFnCMxUzS/zbhUfSZW305v6fWhf2PDkvEkuxg94/6iCfcXSUwFiZ8Gno4eqd
	 5V1lNjHOwHcU54uKBal1942MgLm5oaPoKnaIoSyRO34vUQGIBdOI8RhAheeDo9r4Nz
	 znC+1oryTa1fw==
From: Christian Brauner <brauner@kernel.org>
To: konishi.ryusuke@gmail.com, hch@lst.de, 
 Viacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-nilfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20260724222745.2107464-1-slava@dubeyko.com>
References: <20260724222745.2107464-1-slava@dubeyko.com>
Subject: Re: [PATCH 0/2] nilfs2: convert O_DIRECT reads to iomap
Message-Id: <20260727-notunterkunft-zerfressen-gewidmet-d2ce28764abf@brauner>
Date: Mon, 27 Jul 2026 11:43:28 +0200
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev-09492
X-Developer-Signature: v=1; a=openpgp-sha256; l=1951; i=brauner@kernel.org;
 h=from:subject:message-id; bh=tBwWYEMHx+hW/22ynowJbTQdQawfP/hz+J0IlS8uazI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSla7iwRVx+5rgh04GL+zvXtIcb6veIWr+RslzBYnHZR
 PWQ04ejHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABMJ5GFk+PSnff1uhbMTnQ2t
 CuPmrzvMF8u+/kkrR8rpFdKX1xgKL2P4Hzcjil//0mZm84MPq9+tThY/Z1xe/FD/2myz6BMs56R
 OMAIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Fri, 24 Jul 2026 15:27:43 -0700, Viacheslav Dubeyko wrote:
> nilfs2: convert O_DIRECT reads to iomap
> 
> This series removes NILFS2 using of blockdev_direct_IO() by
> converting the O_DIRECT read path to iomap. NILFS2 is
> a log-structured, copy-on-write filesystem, which makes it
> a poor fit for a full iomap conversion. Newly allocated blocks
> are delay-allocated by nilfs_get_block() and only receive a real
> disk address when the segment constructor writes them out
> as part of a log. The segment constructor walks buffer_head lists
> directly and is not integrated with the generic address_space
> writeback path. First patch adds a new, read-only nilfs_iomap_ops
> wrapping the existing nilfs_bmap_lookup_contig() lookup.
> The second patch wires that ops table into O_DIRECT reads via
> iomap_dio_rw(), sets FMODE_CAN_ODIRECT explicitly on open, and
> removes nilfs_direct_IO() and the .direct_IO callback entirely.
> O_DIRECT writes are explicitly downgraded to the ordinary buffered
> write path in nilfs_file_write_iter().
> 
> [...]

Applied to the vfs-7.3.nilfs2 branch of the vfs/vfs.git tree.
Patches in the vfs-7.3.nilfs2 branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.3.nilfs2

[1/2] nilfs2: add iomap operations for direct I/O reads
      https://git.kernel.org/vfs/vfs/c/e7b2c51c3fed
[2/2] nilfs2: switch O_DIRECT reads to iomap
      https://git.kernel.org/vfs/vfs/c/b924d8d4e54f

