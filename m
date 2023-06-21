From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 00/79] fs: new accessors for inode->i_ctime
Date: Wed, 21 Jun 2023 15:21:41 -0400
Message-ID: <20230621152141.5961cf5f@gandalf.local.home>
References: <20230621144507.55591-1-jlayton@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=Content-Transfer-Encoding:Content-Type:MIME-Version
 :References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=f7ZPpeY/pUTL/3pt09RFwymSSI1p5pOpdla6e7cL0TQ=; b=M+cDxDViENXMv+nwY6z7+e1SWj
 YZf7OaHhuwcvIP5EAx2eguZ38xuCbzW7FVES+NZbEVYGUNjJkPqlfsrX4702RCNZePs52Gzj4ZIxz
 hZASiQ0fHG7wSjEdRYJyNa+ndmR+r371DANIBBn4+nX+xY1goT0if1uZpm7IvThmcnWI=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
 In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=f7ZPpeY/pUTL/3pt09RFwymSSI1p5pOpdla6e7cL0TQ=; b=XHEa2S0iqKqfmefCzF+dV+umJr
 2VnVnTyCUg669brdUdJH2/z6+lqPDTWkEPl8RCPgE//O524vGkf3jidSs2TnTu3zFCmUMdHwehYbv
 o9pKLqxZ4/gZMtRNKnBedpHQWNjnKXg04tAO9uGrpwnsIa7X6N0yaSbQU4SaDILuU+nc=;
In-Reply-To: <20230621144507.55591-1-jlayton@kernel.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Jeff Layton <jlayton@kernel.org>
Cc: Latchesar Ionkov <lucho@ionkov.net>, "Rafael
 J. Wysocki" <rafael@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, Anders Larsen <al@alarsen.net>, Carlos Llamas <cmllamas@google.com>, Andrii Nakryiko <andrii@kernel.org>, Hugh Dickins <hughd@google.com>, John Johansen <john.johansen@canonical.com>, Seth Forshee <sforshee@digitalocean.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christoph Hellwig <hch@lst.de>, Mike Marshall <hubcap@omnibond.com>, Paulo Alcantara <pc@manguebit.com>, linux-xfs@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, Michael Ellerman <mpe@ellerman.id.au>, John Keeping <john@keeping.me.uk>, Zhang Yi <yi.zhang@huawei.com>, James Morris <jmorris@namei.org>, Christophe Leroy <christophe.leroy@csgroup.eu>, Tyler Hicks <code@tyhicks.com>, Alan Stern <stern@rowland.harvard.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, devel@lists.ora

On Wed, 21 Jun 2023 10:45:05 -0400
Jeff Layton <jlayton@kernel.org> wrote:

> Most of this conversion was done via coccinelle, with a few of the more
> non-standard accesses done by hand. There should be no behavioral
> changes with this set. That will come later, as we convert individual
> filesystems to use multigrain timestamps.

BTW, Linus has suggested to me that whenever a conccinelle script is used,
it should be included in the change log.

-- Steve
