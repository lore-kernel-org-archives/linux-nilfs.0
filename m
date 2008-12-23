From: Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Some nilfs comments
Date: Tue, 23 Dec 2008 15:49:09 -0500
Message-ID: <1230065349.5908.7.camel@think.oraclecorp.com>
References: <1229568775.27170.134.camel@think.oraclecorp.com>
	<20081222.180719.88488712.ryusuke@osrg.net>
	<20081222130152.GA23725@aardappel.13thmonkey.org>
	<20081224.022337.30445207.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20081224.022337.30445207.ryusuke-sG5X7nlA6pw@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org, users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

On Wed, 2008-12-24 at 02:23 +0900, Ryusuke Konishi wrote:

> > > Thanks, I've also started to read btrfs.
> > > I'll see it during the Christmas holidays  ;)
> > 
> > Whats your first impression? Want to take over things/ideas? Isn't that a
> > quite different FS structurally since it doesn't have segments? (AFAIK!)
> 
> Yeah, btrfs has flexible and rich volume management layer, so very
> interesting.  The snapshot code and c-tree also look like fun.

The ctree (checksummed btree is really what it stands for) code itself
is pretty basic.  Aside from the checksumming, it is a simple btree with
generation numbers to find the nodes that have changed since a given
transaction.

In terms of interesting/new code that others might want look at, the
btrfs tree logging to do fsync efficiently (tree-log.c) and device
management (volumes.c) are probably the most interesting.

-chris
