<?php

namespace HotfixBundle\Cache;

use Oro\Bundle\EntityExtendBundle\Tools\ExtendClassLoadingUtils;
use Symfony\Component\HttpKernel\CacheWarmer\CacheWarmer;

/**
 * This class solves the issue that occurs during cache clear in prod env.
 *
 * @link https://github.com/orocrm/platform/issues/287#issuecomment-205026924
 */
class EntityAliasCacheWarmer extends CacheWarmer
{
    /**
     * {@inheritdoc}
     */
    public function warmUp($cacheDir)
    {
        ExtendClassLoadingUtils::setAliases($cacheDir);
    }

    /**
     * {@inheritdoc}
     */
    public function isOptional()
    {
        return false;
    }
}
