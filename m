From: Reinoud Zandijk <reinoud-S783fYmB3Ccdnm+yROfE0A@public.gmane.org>
Subject: Re: How does NILFS2 handle directory management
Date: Mon, 14 Sep 2009 12:27:31 +0200
Message-ID: <20090914102731.GA154@aardappel.13thmonkey.org>
References: <20090910192619.GA1263@heethoofdje.13thmonkey.org>
	<20090911.102118.69189169.ryusuke@osrg.net>
	<20090911052213.GA24899@aardappel.13thmonkey.org>
	<20090911.154452.43227079.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090911.154452.43227079.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

On Fri, Sep 11, 2009 at 03:44:52PM +0900, Ryusuke Konishi wrote:
> You mean hashing (on-memory) by file names?
> Well, I agree.  Such optimization would improve directory operations of
> the current code without disk format change.

Well, the strength is that you don't remember the directory contents, only the
hashes, diroffset and name length; this means nearly no memory use. Its also
authorative: not found in the hash means its not in the dir.

> I think it should be considered along with ext3 approach.

What is is the ext3 approach? What is different compared to ext2? And is it
really such a big improvement? Will it complicate directory reading/writing
more?

With regards,
Reinoud Zandijk
