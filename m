From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] nilfs2: fix data loss in mmap page write for
 hole blocks
Date: Mon, 11 Apr 2011 12:04:50 -0700
Message-ID: <20110411190450.GA26763@kroah.com>
References: <20110402.114711.84476230.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <stable-bounces@linux.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110402.114711.84476230.ryusuke@osrg.net>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <http://linux.kernel.org/mailman/options/stable>,
	<mailto:stable-request@linux.kernel.org?subject=unsubscribe>
List-Archive: <http://linux.kernel.org/mailman/private/stable/>
List-Post: <mailto:stable@linux.kernel.org>
List-Help: <mailto:stable-request@linux.kernel.org?subject=help>
List-Subscribe: <http://linux.kernel.org/mailman/listinfo/stable>,
	<mailto:stable-request@linux.kernel.org?subject=subscribe>
Sender: stable-bounces@linux.kernel.org
Errors-To: stable-bounces@linux.kernel.org
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: linux-nilfs@vger.kernel.org, stable@kernel.org

On Sat, Apr 02, 2011 at 11:47:11AM +0900, Ryusuke Konishi wrote:
> Please consider including the attached patch to stable trees between
> 2.6.30 and 2.6.37.

Thanks, I've used this version for the .32 and .33-stable trees.

greg k-h

_______________________________________________
stable mailing list
stable@linux.kernel.org
http://linux.kernel.org/mailman/listinfo/stable
