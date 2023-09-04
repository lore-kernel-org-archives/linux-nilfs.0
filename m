From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v6 00/11] io_uring getdents
Date: Mon, 4 Sep 2023 11:57:30 +0200
Message-ID: <20230904-butterbrot-aufraffen-db483c53eab5@brauner>
References: <20230827132835.1373581-1-hao.xu@linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-cachefs-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693821468;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VnABkwF+s5o3g4Avbih8nHLo+kUbv2Y7SokewzXf+5I=;
	b=dZPYZ2vLDkFU7A4sGX6rBmaodyShWOOqYskZ6TLQ6ViLYbD3C09tbHX5adDTgFErtLazM7
	SRYwJvWYUMAiforATsESmkrQY/PC7ydJ5TZL8hDjeASR0yiX83puzPhrsBjqdvjhCH9Zot
	M8eKShFv/rsDBkldiuriKF9MmIdP6zw=
In-Reply-To: <20230827132835.1373581-1-hao.xu@linux.dev>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/linux-cachefs>, 
 <mailto:linux-cachefs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/linux-cachefs/>
List-Post: <mailto:linux-cachefs@redhat.com>
List-Help: <mailto:linux-cachefs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/linux-cachefs>,
 <mailto:linux-cachefs-request@redhat.com?subject=subscribe>
Errors-To: linux-cachefs-bounces@redhat.com
Sender: "Linux-cachefs" <linux-cachefs-bounces@redhat.com>
Content-Disposition: inline
To: Hao Xu <hao.xu@linux.dev>
Cc: Wanpeng Li <wanpengli@tencent.com>, "Darrick J . Wong" <djwong@kernel.org>, Dominique Martinet <asmadeus@codewreck.org>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>, linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org, codalist@coda.cs.cmu.edu, cluster-devel@redhat.com, linux-cachefs@redhat.com, linux-ext4@vger.kernel.org, devel@lists.orangefs.org, linux-cifs@vger.kernel.org, ecryptfs@vger.kernel.org, linux-block@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org, b

On Sun, Aug 27, 2023 at 09:28:24PM +0800, Hao Xu wrote:

For the future it would be helpful to hold of on sending larger series
that like this until a stable tag is out.

Right now this series is generating a bunch of merge conflicts because
of all the changes to relevant codepaths that got merged. So either we
have to resolve them to see whether things still make sense within the
context of all the changed code or risk that stuff we comment is outdated.
