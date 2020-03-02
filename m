From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 00/44] Manually convert filesystem FS documents to ReST
Date: Mon, 2 Mar 2020 14:13:16 -0700
Message-ID: <20200302141316.4269b22d@lwn.net>
References: <cover.1581955849.git.mchehab+huawei@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=m.gmane-mx.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20170209; h=Sender:
	Content-Transfer-Encoding:Content-Type:Cc:List-Subscribe:List-Help:List-Post:
	List-Archive:List-Unsubscribe:List-Id:MIME-Version:References:In-Reply-To:
	Message-ID:Subject:To:From:Date:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Owner; bh=/K6Pjf8bwlMcB0q5Ez8hNsmE5loIn7Rb+C7vd8pdsXU=; b=efpjMFUx6v8afC
	s20yaen/z783SmO45zp2MKb81mWu1cpNJgbJe/mJhw/DGayYxvQEVdxs2R9XJDyxJQWGT9Q+fl/1g
	1pCfNf3g2CPaPuyuCBj5O4ezRrshs2hGnXla5KA70gJT0gWi3zL4zK+EFyzRgKq599cW58cGJczfr
	QClcOLrsmbfVYv+Q8/6SpIQtS7sQGTsQwHhyqvZ4Q6pOug57g3JNGFkuK5i7oZXFpVS5jPMvPjHMK
	0oSSmebHKS7r5xBwVvXQXX0d556Pw20L5xHkuftfyEgKjjBW81s69GfjseZPDWJn6LwMngo+NcNaJ
	EPAFedE4gt3mNqc6NDEA==;
In-Reply-To: <cover.1581955849.git.mchehab+huawei@kernel.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=m.gmane-mx.org@lists.infradead.org
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Latchesar Ionkov <lucho@ionkov.net>, Martin Brandenburg <martin@omnibond.com>, Jan Kara <jack@suse.cz>, Linux Doc Mailing List <linux-doc@vger.kernel.org>, Dominique Martinet <asmadeus@codewreck.org>, Amir Goldstein <amir73il@gmail.com>, Bob Copeland <me@bobcopeland.com>, David Howells <dhowells@redhat.com>, Joseph Qi <joseph.qi@linux.alibaba.com>, linux-mtd@lists.infradead.org, Tyler Hicks <code@tyhicks.com>, linux-afs@lists.infradead.org, Mike Marshall <hubcap@omnibond.com>, Naohiro Aota <naohiro.aota@wdc.com>, Christoph Hellwig <hch@infradead.org>, linux-nilfs@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>, Sage Weil <sage@redhat.com>, Richard Weinberger <richard@nod.at>, Mark Fasheh <mark@fasheh.com>, Chris Mason <clm@fb.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, cluster-devel@redhat.com, v9fs-developer@lists.sourceforge.net, Gao Xiang <xiang@kern>

On Mon, 17 Feb 2020 17:11:46 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> There are lots of plain text documents under Documentation/filesystems.
> 
> Manually convert several of those to ReST and add them to the index file.

OK, I've finally managed to add all the acks and wrestle this pile into
docs-next - thanks.

jon

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
